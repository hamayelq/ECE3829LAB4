//Lab 4
//Hamayel Qureshi & Nam Tran Ngoc

#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include "xil_printf.h"
#include "xiomodule.h"
#include "sleep.h"

#define UP 				'w'
#define DOWN 			's'
#define LEFT			'a'
#define RIGHT			'd'

#define MAX_WIDTH 		640
#define MAX_HEIGHT 		480
#define BIT_WIDTH 		10
#define BIT_HEIGHT 		9
#define STEP_SIZE 		32

#define CHANNEL_I_SW 	1
#define CHANNEL_I_PBTTN 2

#define CHANNEL_O_VGA	1
#define CHANNEL_O_SEG	2
#define CHANNEL_O_LED 	3
#define CHANNEL_O_COLOR	4

#define BOUNCE_SIZE 20

enum states {
	WASD,
	BOUNCE
} state;

// Extra credit setup
int xspeed = 10;
int yspeed = 10;
int xpos = 320;
int ypos = 240;

void checkCollision();
void pickColor();
void sendDisplay(XIOModule mod, int hor, int ver);
void sendSeg(XIOModule mod, int a, int b, int c, int d);

int main() {
	init_platform();
	u32 data;
	XIOModule IOmod;

	//Part 1 set up
	uint32_t ver = ((MAX_HEIGHT / STEP_SIZE) - 1) / 2 * STEP_SIZE;    //init pos
	uint32_t hor = ((MAX_WIDTH / STEP_SIZE) - 1) / 2 * STEP_SIZE;    //init pos

	u16 move = 0;
	u8 inputBuf[10];    //keyboard input buffer

	//Part 2 set up
	u16 ledButPush = 0; //primitive debouncer
	u8 ledOut = 1;      //LED output high
	u32 col = 0x019;   //default color, 019 is green

	data = XIOModule_Initialize(&IOmod, XPAR_IOMODULE_0_DEVICE_ID);
	data = XIOModule_Start(&IOmod);

	XIOModule_DiscreteWrite(&IOmod, CHANNEL_O_COLOR, col);    //send first color!
	srand(0);

	state = WASD; // Init state, starts with default WASD

	while (1) {  //run constantly
		data = XIOModule_Recv(&IOmod, inputBuf, 1);
		switch (state) {
		//moving block logic
		case WASD:
			//if no previous movement input, check for valid input then change move to 1
			if (move == 0) {
				if (inputBuf[0] == UP) {
					if (ver <= STEP_SIZE || ver <= 0) {
						ver = MAX_HEIGHT - STEP_SIZE;
					} else {
						ver -= STEP_SIZE;
					}
					move = 1;

				} else if (inputBuf[0] == DOWN) {
					ver += STEP_SIZE;
					move = 1;

				} else if (inputBuf[0] == RIGHT) {
					hor += STEP_SIZE;
					move = 1;
				} else if (inputBuf[0] == LEFT) {
					if (hor <= STEP_SIZE || hor <= 0) {
						hor = MAX_WIDTH - STEP_SIZE;
					} else {
						hor -= STEP_SIZE;
					}
					move = 1;
				}
			}
			//set move to 0 if not pressed
			if (inputBuf[0] != UP && inputBuf[0] != DOWN && inputBuf[0] != RIGHT
					&& inputBuf[0] != LEFT) {
				move = 0;
			}

			hor = hor % MAX_WIDTH;
			ver = ver % MAX_HEIGHT;

			//send block movement
			sendDisplay(IOmod, hor, ver);

			//seven seg logic
			uint16_t ver_seg = ver / STEP_SIZE;
			uint16_t hor_seg = hor / STEP_SIZE;

			u16 B = ver_seg >= 10 ? 1 : 0; //vertical tens
			u16 A = ver_seg >= 10 ? ver_seg - 10 : ver_seg; //vertical ones
			u16 D = hor_seg >= 10 ? 1 : 0; //hor tens
			u16 C = hor_seg >= 10 ? hor_seg - 10 : hor_seg; //hor ones
			sendSeg(IOmod, A, B, C, D);

			//terminal display
			data = XIOModule_DiscreteRead(&IOmod, CHANNEL_I_SW);
			if (data == 1) {
				xil_printf("BlockPos x: %d, y: %d \t hor: %d, ver: %d\n\r", hor,
						ver, hor_seg, ver_seg);
			} else if(data > 1) {
				state = BOUNCE;
			}

			//LED logic
			data = XIOModule_DiscreteRead(&IOmod, CHANNEL_I_PBTTN);
			if (!ledButPush && data) {
				xil_printf(
						"Welcome to Lab 4, written by Hamayel Qureshi and Nam Tran\n\r");
				ledOut <<= 1;
				if (ledOut == 16) {
					ledOut = 1;
				}
				ledButPush = 1;
			}

			if (!data) {
				ledButPush = 0;
			}
			XIOModule_DiscreteWrite(&IOmod, CHANNEL_O_LED, ledOut);

			//reset vals
			inputBuf[0] = 0;
			col = 0;
			break;
		case BOUNCE:
			xil_printf("You are now in the B O U N C E Z O N E\n\r");

			xpos+=xspeed;
			ypos+=yspeed;
			checkCollision(IOmod);
			sendDisplay(IOmod, xpos, ypos);
			// 60FPS babyyy
			usleep(16666);

			data = XIOModule_DiscreteRead(&IOmod, CHANNEL_I_SW);
			if(data < 2) {
				state = WASD;
			}
			break;
		}
	}

	cleanup_platform();
	return 0;
}

// Pick a random color
void pickColor(XIOModule mod) {
	uint8_t r = rand() % 15;
	uint8_t g = rand() % 15;
	uint8_t b = rand() % 15;

	uint16_t rgb = (r << 8) | (b << 4) | g;
	XIOModule_DiscreteWrite(&mod, CHANNEL_O_COLOR, rgb);    //send first color!
}

// Check for border collision
void checkCollision(XIOModule mod) {
	if(xpos+BOUNCE_SIZE >= MAX_WIDTH || xpos <= 0) {
		xspeed *= -1;
		pickColor(mod);
	}

	if(ypos+BOUNCE_SIZE >= MAX_HEIGHT || ypos <= 0) {
		yspeed *= -1;
		pickColor(mod);
	}
}

void sendDisplay(XIOModule mod, int hor, int ver) {
	u32 blockPos = 0;
	blockPos |= hor;  //first 10 bits of blockPos hold horizontal pos
	blockPos <<= BIT_HEIGHT; //horizontal left shifted by 9, keep first 9 open
	blockPos |= ver; //first 9 bits of blockPos hold ver, 10 bits in blockPos
	XIOModule_DiscreteWrite(&mod, CHANNEL_O_VGA, blockPos); //send data
}

void sendSeg(XIOModule mod, int a, int b, int c, int d) {
	u16 sevenSegOut = 0;
	sevenSegOut |= d;
	sevenSegOut <<= 4;
	sevenSegOut |= c;
	sevenSegOut <<= 4;
	sevenSegOut |= b;
	sevenSegOut <<= 4;
	sevenSegOut |= a;
	XIOModule_DiscreteWrite(&mod, CHANNEL_O_SEG, sevenSegOut);
}
