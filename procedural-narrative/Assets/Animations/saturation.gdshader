shader_type canvas_item;

uniform float saturation : hint_range(0.0, 2.0) = 0.55;
uniform float brightness : hint_range(0.0, 2.0) = 0.5;
uniform float blur : hint_range(0.0, 2.0) = 0.8; 
uniform sampler2D minha_textura : filter_linear_mipmap;


void fragment() {
    // 1. Lê a imagem do Panel (TEXTURE) aplicando o desfoque (blur)
    vec4 tex_color = textureLod(minha_textura, UV, blur);
    
    // 2. Aplica o brilho à imagem
    tex_color.rgb *= brightness;
    
    // 3. Calcula a escala de cinza para a saturação
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    
    // 4. Mistura a imagem com a saturação desejada
    vec3 final_color = mix(vec3(gray), tex_color.rgb, saturation);
   
    // 5. Devolve o resultado final mantendo a transparência original da imagem
    COLOR = vec4(final_color, tex_color.a);
}
