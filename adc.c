#include<LPC17xx.h>

int temp1,temp2,flag1,flag2;
port_write(){
	int i;
	LPC_GPIO0->FIOPIN = temp2<<23;
	
	if(flag1 == 0){
		LPC_GPIO0->FIOSET=1<<27;
	}
	else LPC_GPIO0->FIOCLR=1<<27;
	
	//enable
	LPC_GPIO0->FIOSET = 1<<28;
	for(i=0;i<50;i++);
	LPC_GPIO0->FIOCLR = 1<<28;
	for(i=0;i<50;i++);
}

LCD_write(){
	if((flag1 == 0) & (temp1==0x30 || temp1==0x20)) flag2 = 0;
	else flag2 = 1;
	
	temp2 = temp1>>4;
	port_write();
	
	if(flag2 == 0){
		temp2 = temp1 & 0xf;
		port_write();
	}
}

int main(){
	int adc_temp;
	double in_vtg;
	double ref_vtg = 3.3;
	char dval[50],vtg[50];
	int i;
	char l1[] = "Analog IP:";
	char l2[] = "ADC Output:";
	int lcd_init[] = {0x30,0x30,0x30,0x20,0x28,0x0c,0x01,0x80,0x6};
	SystemInit();
	SystemCoreClockUpdate();
	
	LPC_SC->PCONP |= 1<<15; //enable GPIO0 block
	LPC_SC->PCONP |=1<<12; //enable adc periperal
	
	LPC_PINCON->PINSEL1 = 0;
	LPC_PINCON->PINSEL3 = 3<<30; //p1.31in func 3 for ad0.5
	
	LPC_GPIO0->FIODIR = 0xf<<23|1<<27|1<<28; // for lcd

	//line 1
	flag1 = 0;
	temp1 = 0x80;
	LCD_write();
	flag1 = 1;
	for(i=0;l1[i]!='/0';i++){
		temp1 = l1[i];
		LCD_write();
	}
	
	//line 2
	flag1 = 0;
	temp1 = 0xc0;
	LCD_write();
	flag1 = 0;
	for(i=0;l2[i]!='/0';i++){
		temp1 = l2[i];
		LCD_write();
	}
	
	while(1){
		LPC_ADC->ADCR = 1<<5|1<<21|1<<24; // 5 is the channel number, 21 is the done bit, 24 initiates the start of the adc conversion
		
		while(!(LPC_ADC->ADGDR >> 31 & 1));
		
		adc_temp = LPC_ADC->ADGDR;
		adc_temp = (adc_temp >> 4) & 0xfff;
		
		in_vtg = (((float)adc_temp * (float)ref_vtg /(float)0xfff));
		
		sprintf(vtg,"%3.2fV",in_vtg);
		sprintf(dval,"%x",adc_temp);
		
		// writing it on the lcd 
		flag1 = 0;
		temp1 = 0x8b;
		LCD_write();
		flag1 = 1;
		for(i=0;vtg[i]='/0';i++){
			temp1 = vtg[i];
			LCD_write();
		}
		
		flag1 = 0;
		temp1 = 0xc8;
		LCD_write();
		flag1 = 1;
		for(i=0;dval[i]!='/0';i++){
			temp1 = dval[i];
			LCD_write();
		}
	}
}
