#include <lpc17xx.h>
step_pos[]= { 3,9,C,6};
int main (void)
{
unsigned int m,i;
SystemInit();
SystemCoreClockUpdate();
LPC_GPIO0->FIODIR = 0x0F;// Output
while ( 1 )
{
for(i=0; i < 150; i++)
{
LPC_GPIO0->FIOPIN = step_pos[i % 4];
delay(); //Use Timer delay for 16.67 ms
}
}
