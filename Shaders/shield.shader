shader_type canvas_item;

uniform float outLineSize  = 0.02;
uniform vec4  outLineColor = vec4(1.0, 0.0, 0.0, 1.0);

void fragment()
{
    vec4 tcol = texture(TEXTURE, UV);
    
    if (tcol.a != 0.0)
    {
        tcol.b += 1.0 + cos(TIME * 5.0);
    }
    
    COLOR = tcol;
}