#version 150

#moj_import <fog.glsl>
#moj_import <light.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
	vec3 pos = Position;

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = Color;
    texCoord0 = UV0;

	vec2 pixel = vec2(ProjMat[0][0], ProjMat[1][1]) / 2.0;
	int guiScale = int(round(pixel.x / (1 / ScreenSize.x)));
	vec2 guiSize = ScreenSize / guiScale;

	int offset = int(round(guiSize.y - Position.y));
	
	// Detect if GUI text.
	if (Position.z == 0.0) {
		// Detect ascent of pixel.
		if (offset > -130000 && offset <= -100000) {
			int value = 100000;

			int detect = offset + value;
			if (detect > -30000 && detect <= -20000) {
				value += 20000;
				pos += vec3(0.0,(guiSize.y * -1), 0.0); // Top
			} 
			else if (detect > -20000 && detect <= -10000) {
				value += 10000;
				pos += vec3(0.0,((guiSize.y/2) * -1), 0.0); // Center
			} 
			else if (detect > -10000 && detect <= 0) {
				// does nothing.
			} 

			value += 5000;
			pos.y -= value;
		}
	} 

	gl_Position = ProjMat * ModelViewMat * vec4(pos, 1);
}
