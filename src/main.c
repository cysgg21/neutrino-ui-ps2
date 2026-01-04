#include <tamtypes.h>
#include <kernel.h>
#include <sifrpc.h>
#include <gsKit.h>
#include <dmaKit.h>
#include <string.h>

extern unsigned char _binary_assets_build_bg_raw_start[];
extern unsigned char _binary_assets_build_disc_raw_start[];

static void setup_dma()
{
    dmaKit_init(D_CTRL_RELE_OFF, D_CTRL_MFD_OFF, D_CTRL_STS_UNSPEC,
                D_CTRL_STD_OFF, D_CTRL_RCYC_8);
    dmaKit_chan_init(DMA_CHANNEL_GIF);
}

static void init_tex_from_raw16(GSGLOBAL* gs, GSTEXTURE* t, int w, int h, void* raw)
{
    memset(t, 0, sizeof(*t));
    t->Width  = w;
    t->Height = h;
    t->PSM    = GS_PSM_CT16;          // 16-bit
    t->Filter = GS_FILTER_NEAREST;
    t->Mem    = raw;

    gsKit_texture_upload(gs, t);
}

int main(int argc, char *argv[])
{
    SifInitRpc(0);
    setup_dma();

    GSGLOBAL *gs = gsKit_init_global();
    gs->Mode = GS_MODE_NTSC;
    gs->Width = 640;
    gs->Height = 448;
    gs->Interlace = GS_INTERLACED;
    gs->Field = GS_FIELD;
    gs->PSM = GS_PSM_CT16;

    gsKit_init_screen(gs);

    GSTEXTURE tex_bg, tex_disc;
    init_tex_from_raw16(gs, &tex_bg,   640, 448, _binary_assets_build_bg_raw_start);
    init_tex_from_raw16(gs, &tex_disc, 32,  32,  _binary_assets_build_disc_raw_start);

    while (1)
    {
        // Fondo
        gsKit_prim_sprite_texture(gs, &tex_bg,
            0, 0, 0, 0,
            640, 448, 640, 448,
            1, GS_SETREG_RGBAQ(0x80,0x80,0x80,0x80,0x00));

        // Icono disco
        int x = 18, y = 18;
        gsKit_prim_sprite_texture(gs, &tex_disc,
            x, y, 0, 0,
            x+32, y+32, 32, 32,
            2, GS_SETREG_RGBAQ(0x80,0x80,0x80,0x80,0x00));

        gsKit_sync_flip(gs);
        gsKit_queue_exec(gs);
        gsKit_queue_reset(gs);
        WaitSema(gs->sema);
    }

    return 0;
}
