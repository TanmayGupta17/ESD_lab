#include <LPC17xx.h>

// LCD pins configuration
// P0.27 for RS
// P0.28 for Enable
// P0.26 to P0.23 for input lines

int temp1, temp2, flag1, flag2;
int seven_seg[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71};
char keymap[16] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'}; // Mapping for 4x4 keypad

void delay(unsigned int count)
{
    int i;
    for(i = 0; i < count; i++);
}

void port_write()
{
    LPC_GPIO0->FIOPIN = temp2 << 23;
    
    if(flag1 == 0)
        LPC_GPIO0->FIOCLR = 1 << 27;
    else
        LPC_GPIO0->FIOSET = 1 << 27;
    
    LPC_GPIO0->FIOSET = 1 << 28;
    delay(50);
    LPC_GPIO0->FIOCLR = 1 << 28;
    
    delay(3000);
}

void LCD_write()
{
    if((flag1 == 0) & ((temp1 == 0x30) || (temp1 == 0x20)))
        flag2 = 1;
    else
        flag2 = 0;
    
    temp2 = temp1 >> 4;
    port_write();
    
    if(flag2 == 0)
    {
        temp2 = temp1 & 0xF;
        port_write();
    }
}

void LCD_init()
{
    int i;
    int lcd_init[] = {0x30, 0x30, 0x30, 0x20, 0x28, 0x0C, 0x01, 0x80, 0x06};
    
    flag1 = 0;
    for(i = 0; i <= 8; i++)
    {
        temp1 = lcd_init[i];
        LCD_write();
    }
    flag1 = 1;
}

void LCD_char(char c)
{
    flag1 = 1;
    temp1 = (int)c;
    LCD_write();
}

void LCD_cmd(char command)
{
    flag1 = 0;
    temp1 = command;
    LCD_write();
}

void clear_LCD()
{
    LCD_cmd(0x01);  // Clear display
    LCD_cmd(0x80);  // Move cursor to beginning of first line
}

int main(void)
{
    unsigned int row = 0, col = 0, keycode = 0;
    int x, cursor_pos = 0;
    
    SystemInit();
    SystemCoreClockUpdate();
    
    // Configure pins
    LPC_PINCON->PINSEL0 = 0;
    LPC_PINCON->PINSEL1 = 0;
    LPC_PINCON->PINSEL3 = 0;
    LPC_PINCON->PINSEL4 = 0;
    
    // Configure GPIO directions
    LPC_GPIO0->FIODIR = 0xF << 23 | 1 << 27 | 1 << 28;  // LCD pins
    LPC_GPIO1->FIODIR = 0;  // Input for columns
    LPC_GPIO2->FIODIR = 0xF << 10;  // Output for rows
    
    // Initialize LCD
    LCD_init();
    clear_LCD();
    
    while(1)
    {
        for(row = 0; row < 4; row++)
        {
            LPC_GPIO2->FIOPIN = 1 << (10 + row);
            delay(100);
            
            x = LPC_GPIO1->FIOPIN;
            x = (x >> 23) & 0xF;
            
            if(x != 0)
            {
                if(x == 1) col = 0;
                else if(x == 2) col = 1;
                else if(x == 4) col = 2;
                else if(x == 8) col = 3;
                
                keycode = 4 * row + col;
                
                // Display the pressed key on LCD
                if(cursor_pos == 16)  // Move to second line after 16 characters
                {
                    LCD_cmd(0xC0);  // Move to second line
                }
                else if(cursor_pos == 32)  // Clear screen after 32 characters
                {
                    clear_LCD();
                    cursor_pos = 0;
                }
                
                LCD_char(keymap[keycode]);  // Display the character
                cursor_pos++;
                
                // Debounce delay
                delay(500000);
            }
        }
    }
}
