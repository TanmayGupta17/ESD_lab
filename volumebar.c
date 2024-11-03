#include <LPC17xx.h>
#include <stdio.h>

int temp1, temp2, flag1, flag2;

// [LCD functions remain same]
void port_write() {
    // [Same as your original]
}

void LCD_write() {
    // [Same as your original]
}

// IMPROVED: LED control function with better scaling
void controlLEDs(int adcValue) {
    int ledPattern = 0;
    int ledCount = (adcValue * 8) / 4095; // Map ADC value (0-4095) to 0-8 LEDs
    
    // Create pattern with sequential LEDs lit
    for(int i = 0; i <= ledCount; i++) {
        ledPattern |= (1 << i);
    }
    
    // Update LEDs (P0.0 to P0.7)
    LPC_GPIO0->FIOCLR = 0xFF;        // Clear all LEDs first
    LPC_GPIO0->FIOSET = ledPattern;  // Set new pattern
}

int main() {
    int adc_temp;
    double in_vtg;
    double ref_vtg = 3.3;
    char dval[50], vtg[50];
    int i;
    char l1[] = "Analog IP:";
    char l2[] = "ADC Output:";
    int lcd_init[] = {0x30, 0x30, 0x30, 0x20, 0x28, 0x0c, 0x01, 0x80, 0x06};
    
    SystemInit();
    SystemCoreClockUpdate();
    
    // Enable peripherals
    LPC_SC->PCONP |= (1 << 15);  // Enable GPIO0
    LPC_SC->PCONP |= (1 << 12);  // Enable ADC
    
    // Pin configuration
    LPC_PINCON->PINSEL1 = 0;
    LPC_PINCON->PINSEL3 = (3 << 30);  // P1.31 as AD0.5
    
    // Configure GPIO directions
    // IMPROVED: Clearer GPIO configuration
    LPC_GPIO0->FIODIR = 0xFF |         // LED pins (P0.0-P0.7)
                        (1 << 27) |     // LCD RS pin
                        (1 << 28) |     // LCD EN pin
                        (0xF << 23);    // LCD data pins
    
    // Initialize LCD
    flag1 = 0;
    for(i = 0; i < 9; i++) {
        temp1 = lcd_init[i];
        LCD_write();
        for(int j = 0; j < 10000; j++);  // Delay for LCD init
    }
    
    // Write initial LCD text
    // Line 1
    flag1 = 0;
    temp1 = 0x80;
    LCD_write();
    flag1 = 1;
    for(i = 0; l1[i] != '\0'; i++) {
        temp1 = l1[i];
        LCD_write();
    }
    
    // Line 2
    flag1 = 0;
    temp1 = 0xc0;
    LCD_write();
    flag1 = 1;
    for(i = 0; l2[i] != '\0'; i++) {
        temp1 = l2[i];
        LCD_write();
    }
    
    while(1) {
        // Start ADC conversion
        LPC_ADC->ADCR = (1 << 5) |    // Select AD0.5
                        (1 << 21) |    // Enable ADC
                        (1 << 24);     // Start conversion
        
        // Wait for conversion complete
        while(!(LPC_ADC->ADGDR >> 31 & 1));
        
        // Get ADC value and calculate voltage
        adc_temp = LPC_ADC->ADGDR;
        adc_temp = (adc_temp >> 4) & 0xFFF;
        in_vtg = (((float)adc_temp * ref_vtg) / 0xFFF);
        
        // Format strings
        sprintf(vtg, "%3.2fV", in_vtg);
        sprintf(dval, "%x", adc_temp);
        
        // Update LCD voltage display
        flag1 = 0;
        temp1 = 0x8B;
        LCD_write();
        flag1 = 1;
        for(i = 0; vtg[i] != '\0'; i++) {
            temp1 = vtg[i];
            LCD_write();
        }
        
        // Update LCD ADC value display
        flag1 = 0;
        temp1 = 0xC8;
        LCD_write();
        flag1 = 1;
        for(i = 0; dval[i] != '\0'; i++) {
            temp1 = dval[i];
            LCD_write();
        }
        
        // Update LED bar display
        controlLEDs(adc_temp);
        
        // Small delay for stability
        for(i = 0; i < 10000; i++);
    }
}
