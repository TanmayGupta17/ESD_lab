#include<LPC17XX.h>
unsigned int j,i;
int main(){
	SystemInit();
	SystemCoreClockUpdate();
	LPC_PINCON->PINSEL0=0xFF0000FF;
	LPC_GPIO0->FIODIR=0x00000FF0;
	
	while(1){
		LPC_GPIO0->FIOSETL=0xFF<<4;
		for(i=0;i<1000;i++);

		LPC_GPIO0->FIOCLRL=0xFF<<4;
		for(j=0;j<1000;j++);
	}
	
}
