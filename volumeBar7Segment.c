#include <LPC17xx.h>
#define ref_vtg 3.3
#define full_scale 0xFFF
#define num_level 8

int seven_seg[] = {0x06,0x36};

void init_adc(){
	LPC_SC->PCONP |= 1<<12; //enable adc
	LPC_PINCON->PINSEL3 = 1<<31;
}

void init_gpio(void) {
    LPC_PINCON->PINSEL0 = 0;
    LPC_PINCON->PINSEL3 = 0;
    LPC_GPIO0->FIODIR = 0xFF << 4;  // Set P0.4-P0.11 as outputs
    LPC_GPIO1->FIODIR = 0xF << 23;  // Set P1.23-P1.26 as outputs
}

unsigned long read_adc(){
	unsigned long adc_val;
	
	LPC_ADC->ADCR = (1<<5)|(1<<21)|(1<<24);
	
	while(!(LPC_ADC->ADGDR>>31 & 1));
	adc_val = LPC_ADC->ADGDR;
	
	return (adc_val>>4 & 0XFFF);
}

int get_volume(unsigned long adc_val){
	return ((adc_val*num_level)/full_scale);
}

void display(int num_value){
	int i,j;
	int temp = num_value;
	int num = temp/2;
	
	for(i=0;i<num+1;i++){
		LPC_GPIO1->FIOPIN = i<<23;
		
		if(temp>1){
			LPC_GPIO0->FIOPIN = seven_seg[1];
			temp -=2;
		}
		else if(temp == 1){
			LPC_GPIO0->FIOPIN = seven_seg[0];
		}
		//for(j = 0; j < 100; j++);
	}
}

int main(){
	unsigned long adc_val;
	int num_val;
	
	SystemInit();
	SystemCoreClockUpdate();
	
	init_adc();
	init_gpio();
	
	while(1){
		adc_val = read_adc();
		num_val = get_volume(adc_val);
		
		display(num_val);
	}
}
