# FuzzConn
Matlab and Mex code for computing Absolute and Relative Fuzzy Connectedness as well as Image Foresting Transform in 2D images 

---

Code I wrote for a lab assignment when teaching the Computer Assisted Image Analysis II Course at the Centre for Image Analysis, Uppsala University back in Fall 2008. The same code was actually later used for bone segmentation in [1]. In case you find this code useful and wish to give credit to it, then please cite [1].


* The file afc.m provides an implementation of Absolute Fuzzy Connectedness according to kFOEMS in [3].
* The files adjacency.m and affinity.m computes adjacency and affinity according to [2].
* The file fctest.m gives an example of how to use the provided functions and to compute a Fuzzy Connected Component.

* The file irfc.m provides an implementation of Iterated Relative Fuzzy Connectedness according to kIR-
MOFS in [4]. That function calls afc.m a number of times to partition an image into components defined
by multiple seeds from at least two classes. Classes are given by seed numbers starting from 1.

* The file ift.m provides an implementation of the Image Foresting Transform (IFT) according to [5] but without tie-breaking (just first pick). The IFT provides very similar result as IRFC but without the need for iterations, and is therefore preferable to use.

* The file fctest2.m gives an example of how to use the provided functions to perform seeded segmentation using Relative Fuzzy Connectedness.


* Files afc.cc and ift.cc provide c++ Mex implementations of the respective m-files. To make everything run a lot faster, execute the following in Matlab:

    \> mex afc.cc  
    \> mex ift.cc

I have tried my best to stay faithfull to the descriptions in the references below.
Do not use on too large images; the code is more aimed at pedagogic use than speed.

/ Joakim


### References
[1] J. Lindblad, N. Sladoje, V. Ćurić, H. Sarve, C.B. Johansson, and G. Borgefors. Improved quantification of bone remodelling by utilizing fuzzy based segmentation. In Proceedings of the 16th Scandinavian Conference on Image Analysis (SCIA), LNCS-5575, pp. 750-759, Oslo, Norway, June 2009. doi:10.1007/978-3-642-02230-2_77 

[2] J.K. Udupa and S. Samarasekera. Fuzzy connectedness and object definition: theory, algorithms, and application in image segmentation. Graphical Models and Image Processing, 58(3):246–261, 1996.

[3] P.K. Saha and J.K. Udupa. Fuzzy connected object delineation: axiomatic path strength definition and the case of multiple seeds. Computer Vision and Image Understanding, 83:275–295, 2001.

[4] K.C. Ciesielski, J.K. Udupa, P.K. Saha, and Y. Zhuge. Iterative relative fuzzy connectedness for multiple objects with multiple seeds. Computer Vision and Image Understanding, 107:160–182, 2007.

[5] F. Malmberg, J. Lindblad, and I. Nyström. Sub-pixel Segmentation with the Image Foresting Transform. In Proceedings of the 13th International Workshop on Combinatorial Image Analysis (IWCIA), LNCS-5852, pp. 201-211, Playa del Carmen, Mexico, Nov. 2009. doi:10.1007/978-3-642-10210-3_16
