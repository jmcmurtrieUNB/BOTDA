#include <stdio.h>
#include "mmp.h"
#include "mex.h"
void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[]){
	double *regist, *output;
	int n_rows, n_cols;
	int i;
	n_cols = mxGetN(prhs[0]);
	//output=mxGetPr(plhs[0]);
	regist = mxGetPr(prhs[0]);


	MMPOpen();
	MMPOutp(0x378, 0x00);
	Sleep(1);
	//MMPOutp(0x378, 0x03);	// Clock in Data bit
	//Sleep(1);				// 0b0000 0011 Data=1,CLK=1,LE=0
	//mexPrintf("%f \n",&prhs[3]);
	
	for(i=0;i<=31;i++){
			if(regist[i] == 1){
				MMPOutp(0x378, 0x02);	// 0b0000 0010 Data=1,CLK=0,LE=0
				Sleep(1);
				MMPOutp(0x378, 0x06);	// Clock in Data bit
				Sleep(1);	// 0b0000 0011 Data=1,CLK=1,LE=0
				MMPOutp(0x378, 0x02);
				Sleep(1);
			}
			else{						// When Rvalues[] is 0
				MMPOutp(0x378, 0x00);	// 0b0000 0000 Data=0,CLK=0,LE=0
				Sleep(1);
				MMPOutp(0x378, 0x04);	// Clock in Data bit
				Sleep(1);	// 0b0000 0001 Data=1,CLK=1,LE=0
				MMPOutp(0x378, 0x00);
				Sleep(1);
			}
			//mexPrintf("%i \n",i);
			
	}
		//MMPOutp(0x378, 0x00);			//Reset Port 0b0000 0000 Data=0,CLK=0,LE=0
		//Sleep(1);
		MMPOutp(0x378, 0x08);			//Latch R Register 0b0000 0100 Data=0,CLK=0,LE=1
		Sleep(10);
		//MMPOutp(0x378, 0x00);			//Reset Port 0b0000 0000 Data=0,CLK=0,LE=0 */
	
	
	MMPClose;
	//output=1;
}
