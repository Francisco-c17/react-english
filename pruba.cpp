//============================================================================
// Name        : OpenCVPrueba.cpp
// Author      : Francisco
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

//#include <iostream>
//	cout << "!!!Hello World!!!" << endl; // prints !!!Hello World!!!
//  image = imread("/Users/francisco/Documents/Cursos y certificaciones/OpenCV Vision Artificial/Imagenes/baboon.png", 0);

#include<opencv2/core/core.hpp>
//#include<opencv2/ml/ml.hpp>
#include<opencv/cv.h>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/highgui/highgui.hpp>
#include <iostream>

using namespace cv;
using namespace std;

int main(){
Mat image = imread("/Imagenes/baboon.png", 0);



if (!image.data)
		return 0;

	int filas, columnas;
	filas = image.rows;
   	columnas = image.cols;
   	Mat image_in(filas, columnas, CV_8U, Scalar(0));
	Mat image_not(filas, columnas, CV_8U, Scalar(0));

//invertir imagen
	for (int i = 0; i < filas; i++) {
		for (int j = 0; j < columnas; j++) {

			image_in.at<uchar>(i, j) = image.at<uchar>((filas - 1) - i,
					(columnas - 1) - j);

			//operador not
			image_not.at<uchar>(i, j) = 255 - image.at<uchar>(i, j);

		}
	}








	imshow("Ver imagen original", image);
	imshow("Ver imagen invertida", image_in);
	imshow("Ver imagen negativa", image_not);
	waitKey();




	return 1;
	}
