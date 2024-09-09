#include<LPC17XX.h>
unsigned int j,i;
int main(){
	SystemInit();
	SystemCoreClockUpdate();
	LPC_PINCON -> PINSEL0 = 0;
	LPC_GPIO0 -> FIODIR = 0xF<<4;
	
	while(1){
			for(i=0;i<256;i++){
				LPC_GPIO0 -> FIOPIN = i<<4;
				for(j=0;j<100000;j++);
			}
	}
	
	
}
