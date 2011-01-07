/* Apple8723Container.h - Nanotomy
 * DarkMalloc
 */

#include <inttypes.h>

#define LEN_HEADER 0x400

#define LEN_STRUCTURE sizeof(Apple8723Header)

typedef struct {
	char magic[4]; // "8723"
	char version[3]; // "2.0"
	uint8_t format; // plaintext is 0x4, encrypted is 0x3
	uint32_t unknown1;
	uint32_t sizeOfData;
	uint32_t footerSignatureOffset;
	uint32_t footerCertificateOffset;
	uint32_t footerCertificateLength;
	char salt[0x20]; // blank - no longer used?
	uint16_t unknown2; // blank - unused?
	uint16_t epoch; // blank - unused?
	char headerSignature[0x14];
	char padding[0x3AC];
} Apple8723Header;
