//%function FC=afc(S,K)
//%
//%Absolute Fuzzy Connectedness (kFOEMS) according to Saha and Udupa 2001
//%S is seed image (treated as boolean)
//%K is symmetric matrix of size numel(S)*numel(S) 
//%
//%Author: Joakim Lindblad
//
//% Dijkstra version

//% Copyright (c) 2008-2018, Joakim Lindblad

extern "C" {
#include <mex.h>
	void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);
}

#include <algorithm>
#include <functional>
#include <queue>
#include <assert.h>

#define NO_IDX_CHECK

using namespace std;

/////////////////////////////////////////////////////////////////////////////

template <class type>
class mxxMatrix 
{
protected:
	mxArray* _pm;
	const mwSize _ndims;
	const mwSize* _dims;

public:
	type* ptr;

public:
	mxxMatrix(mxArray *pm) :
	_pm(pm),
	_ndims(mxGetNumberOfDimensions(_pm)),
	_dims(mxGetDimensions(_pm)),
	ptr(static_cast<type*>(mxGetPr(_pm)))
	{}

	//cast
	operator const mxArray* () const { return _pm; }
	operator mxArray* () { return _pm; }

	int rows() const { return (_ndims>0)?_dims[0]:0; }
	int cols() const { return (_ndims>1)?_dims[1]:0; }
	int numel() const { return mxGetNumberOfElements(_pm); }

	const type &operator()(int idx) const { return ptr[idx]; }
	type &operator()(int idx) { return ptr[idx]; }
};

template <class type>
class mxxMatrix<const type>
{
protected:
	const mxArray* _pm;
	const mwSize _ndims;
	const mwSize* _dims;

public:
	type* ptr;

public:
	mxxMatrix(const mxArray *pm) :
	_pm(pm),
	_ndims(mxGetNumberOfDimensions(_pm)),
	_dims(mxGetDimensions(_pm)),
	ptr(static_cast<type*>(mxGetPr(_pm)))
	{}

	//cast
	operator const mxArray* () const { return _pm; }

	int rows() const { return (_ndims>0)?_dims[0]:0; }
	int cols() const { return (_ndims>1)?_dims[1]:0; }
	int numel() const { return mxGetNumberOfElements(_pm); }

	const type &operator()(int idx) const { return ptr[idx]; }
};

template <class type>
struct sparse_col
{
	mwIndex *iBegin,*iEnd;
	type *pBegin,*pEnd;
};

template <class type>
class mxxSparseMatrix : public mxxMatrix<type>
{
	using mxxMatrix<type>::_pm;
	using mxxMatrix<type>::ptr;

	mwIndex *_jc;
	mwIndex *_ir;

public:
	mxxSparseMatrix(const mxArray *pm):mxxMatrix<type>(pm)
	{
		_jc=mxGetJc(_pm);
		_ir=mxGetIr(_pm);
	}

	type operator()(int r, int c) const
	{
#ifndef NO_IDX_CHECK
		assert(0<=r && r<=rows());
		assert(0<=c && c<=cols());
#endif
		mwIndex *p = lower_bound(&_ir[_jc[c]], &_ir[_jc[c+1]], r); //_jc is index in _ir
		if (p!=&_ir[_jc[c+1]] && *p==r) //ptr into _ir
			return ptr[p-_ir];
		else
			return type(0);
	}

	sparse_col<type> get_col(int c) const //non-zero elements in column
	{
#ifndef NO_IDX_CHECK
		assert(0<=c && c<=cols());
#endif
		sparse_col<type> col;
		col.iBegin=&_ir[_jc[c]];
		col.iEnd=&_ir[_jc[c+1]];
		col.pBegin=&ptr[_jc[c]];
		col.pEnd=&ptr[_jc[c+1]];
		return col;
	}
};


/////////////////////////////////////////////////////////////////////////////

//dereference sort
template <class type>
struct dereference_less : public binary_function<const type*, const type*, bool>
{
	bool operator()(const type* x, const type* y) { return (*x) < (*y); }
};

/////////////////////////////////////////////////////////////////////////////
//function FC=afc(S,K)
/////////////////////////////////////////////////////////////////////////////
void afc(const mxxMatrix<const double> &S, const mxxSparseMatrix<const double> &K, mxxMatrix<double> &FC)
{
	priority_queue< double*, vector<double*>, dereference_less<double> > Q;

	const double *s=S.ptr;
	double *fc=FC.ptr;
	for (int i=0;i<S.numel();i++,s++,fc++)	{
		*fc=(*s)?1.0:0.0; //init segm = seeds
		if (*fc) Q.push(fc); //push seed spels on queue
	}

	while (!Q.empty()) {
		double *fc=Q.top(); //pick strongest fc in Q
		Q.pop(); //remove from Q

		//compute and propagate affinity
		sparse_col<const double> col=K.get_col(fc-FC.ptr); //K(:,fc);
		const double* p=col.pBegin;
		for (mwIndex* i=col.iBegin;i!=col.iEnd;++i,++p) {
			double f=min(*fc,*p); //compute fc for adjacent pixels
			if (f>0 && f>FC(*i)) { //find those with real change
				FC(*i)=f; //update FC
				Q.push(FC.ptr+(*i)); //push updated spel
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////
//Mex interface
/////////////////////////////////////////////////////////////////////////////
void mexFunction( int nlhs, mxArray *plhs[],
int nrhs, const mxArray *prhs[])
{
	if(nrhs!=2) mexErrMsgTxt("Two inputs required.");
	if(nlhs!=1) mexErrMsgTxt("One output required.");
	if(mxIsSparse(prhs[0])) mexErrMsgTxt("Seed image S must be non-sparse.");
	if(!mxIsSparse(prhs[1])) mexErrMsgTxt("Affinity K must be sparse.");

	const mxxMatrix<const double> S(prhs[0]);
	const mxxSparseMatrix<const double> K(prhs[1]);

   //create output matrix
	plhs[0] = mxCreateDoubleMatrix(S.rows(),S.cols(), mxREAL);
	mxxMatrix<double> FC(plhs[0]);

	afc(S,K,FC);
}
