#version 330 core

layout (location = 0) in uvec4 loc_uv4_text; // 4个uint的四维向量

varying float[16] m_result;

uniform uint u_x;
uniform uint u_y;
uniform uint u_z;
uniform uint u_w;

const int S11 = 7;
const int S12 = 12;
const int S13 = 17;
const int S14 = 22;
const int S21 = 5;
const int S22 = 9;
const int S23 = 14;
const int S24 = 20;
const int S31 = 4;
const int S32 = 11;
const int S33 = 16;
const int S34 = 23;
const int S41 = 6;
const int S42 = 10;
const int S43 = 15;
const int S44 = 21;

uint F(uint x, uint y, uint z) { return (x & y) | ((~x) & z); }
uint G(uint x, uint y, uint z) { return (x & z) | (y & (~z)); }
uint H(uint x, uint y, uint z) { return x ^ y ^ z; }
uint I(uint x, uint y, uint z) { return y ^ (x | (~z)); }

uint FF(uint a, uint b, uint c, uint d, uint mj, int s, uint ti) {
    a = a + F(b, c, d) + mj + ti;
    a = a << s | a >> (32 - s);
    return a + b;
}
uint GG(uint a, uint b, uint c, uint d, uint mj, int s, uint ti) {
    a = a + G(b, c, d) + mj + ti;
    a = a << s | a >> (32 - s);
    return a + b;
}
uint HH(uint a, uint b, uint c, uint d, uint mj, int s, uint ti) {
    a = a + H(b, c, d) + mj + ti;
    a = a << s | a >> (32 - s);
    return a + b;
}
uint II(uint a, uint b, uint c, uint d, uint mj, int s, uint ti) {
    a = a + I(b, c, d) + mj + ti;
    a = a << s | a >> (32 - s);
    return a + b;
}

uint[4] MD5_Trasform(uint[16] x) {
    
    uint A = uint(0x67452301);
    uint B = uint(0xefcdab89);
    uint C = uint(0x98badcfe);
    uint D = uint(0x10325476);

    uint a = A, b = B, c = C, d = D;
    
    /* Round 1 */
    a = FF(a, b, c, d, x[0], S11, uint(0xd76aa478)); /* 1 */
    d = FF(d, a, b, c, x[1], S12, uint(0xe8c7b756)); /* 2 */
    c = FF(c, d, a, b, x[2], S13, uint(0x242070db)); /* 3 */
    b = FF(b, c, d, a, x[3], S14, uint(0xc1bdceee)); /* 4 */
    a = FF(a, b, c, d, x[4], S11, uint(0xf57c0faf)); /* 5 */
    d = FF(d, a, b, c, x[5], S12, uint(0x4787c62a)); /* 6 */
    c = FF(c, d, a, b, x[6], S13, uint(0xa8304613)); /* 7 */
    b = FF(b, c, d, a, x[7], S14, uint(0xfd469501)); /* 8 */
    a = FF(a, b, c, d, x[8], S11, uint(0x698098d8)); /* 9 */
    d = FF(d, a, b, c, x[9], S12, uint(0x8b44f7af)); /* 10 */
    c = FF(c, d, a, b, x[10], S13, uint(0xffff5bb1)); /* 11 */
    b = FF(b, c, d, a, x[11], S14, uint(0x895cd7be)); /* 12 */
    a = FF(a, b, c, d, x[12], S11, uint(0x6b901122)); /* 13 */
    d = FF(d, a, b, c, x[13], S12, uint(0xfd987193)); /* 14 */
    c = FF(c, d, a, b, x[14], S13, uint(0xa679438e)); /* 15 */
    b = FF(b, c, d, a, x[15], S14, uint(0x49b40821)); /* 16 */

    /* Round 2 */
    a = GG(a, b, c, d, x[1], S21, uint(0xf61e2562)); /* 17 */
    d = GG(d, a, b, c, x[6], S22, uint(0xc040b340)); /* 18 */
    c = GG(c, d, a, b, x[11], S23, uint(0x265e5a51)); /* 19 */
    b = GG(b, c, d, a, x[0], S24, uint(0xe9b6c7aa)); /* 20 */
    a = GG(a, b, c, d, x[5], S21, uint(0xd62f105d)); /* 21 */
    d = GG(d, a, b, c, x[10], S22, uint(0x2441453)); /* 22 */
    c = GG(c, d, a, b, x[15], S23, uint(0xd8a1e681)); /* 23 */
    b = GG(b, c, d, a, x[4], S24, uint(0xe7d3fbc8)); /* 24 */
    a = GG(a, b, c, d, x[9], S21, uint(0x21e1cde6)); /* 25 */
    d = GG(d, a, b, c, x[14], S22, uint(0xc33707d6)); /* 26 */
    c = GG(c, d, a, b, x[3], S23, uint(0xf4d50d87)); /* 27 */
    b = GG(b, c, d, a, x[8], S24, uint(0x455a14ed)); /* 28 */
    a = GG(a, b, c, d, x[13], S21, uint(0xa9e3e905)); /* 29 */
    d = GG(d, a, b, c, x[2], S22, uint(0xfcefa3f8)); /* 30 */
    c = GG(c, d, a, b, x[7], S23, uint(0x676f02d9)); /* 31 */
    b = GG(b, c, d, a, x[12], S24, uint(0x8d2a4c8a)); /* 32 */

    /* Round 3 */
    a = HH(a, b, c, d, x[5], S31, uint(0xfffa3942)); /* 33 */
    d = HH(d, a, b, c, x[8], S32, uint(0x8771f681)); /* 34 */
    c = HH(c, d, a, b, x[11], S33, uint(0x6d9d6122)); /* 35 */
    b = HH(b, c, d, a, x[14], S34, uint(0xfde5380c)); /* 36 */
    a = HH(a, b, c, d, x[1], S31, uint(0xa4beea44)); /* 37 */
    d = HH(d, a, b, c, x[4], S32, uint(0x4bdecfa9)); /* 38 */
    c = HH(c, d, a, b, x[7], S33, uint(0xf6bb4b60)); /* 39 */
    b = HH(b, c, d, a, x[10], S34, uint(0xbebfbc70)); /* 40 */
    a = HH(a, b, c, d, x[13], S31, uint(0x289b7ec6)); /* 41 */
    d = HH(d, a, b, c, x[0], S32, uint(0xeaa127fa)); /* 42 */
    c = HH(c, d, a, b, x[3], S33, uint(0xd4ef3085)); /* 43 */
    b = HH(b, c, d, a, x[6], S34, uint(0x4881d05)); /* 44 */
    a = HH(a, b, c, d, x[9], S31, uint(0xd9d4d039)); /* 45 */
    d = HH(d, a, b, c, x[12], S32, uint(0xe6db99e5)); /* 46 */
    c = HH(c, d, a, b, x[15], S33, uint(0x1fa27cf8)); /* 47 */
    b = HH(b, c, d, a, x[2], S34, uint(0xc4ac5665)); /* 48 */

    /* Round 4 */
    a = II(a, b, c, d, x[0], S41, uint(0xf4292244)); /* 49 */
    d = II(d, a, b, c, x[7], S42, uint(0x432aff97)); /* 50 */
    c = II(c, d, a, b, x[14], S43, uint(0xab9423a7)); /* 51 */
    b = II(b, c, d, a, x[5], S44, uint(0xfc93a039)); /* 52 */
    a = II(a, b, c, d, x[12], S41, uint(0x655b59c3)); /* 53 */
    d = II(d, a, b, c, x[3], S42, uint(0x8f0ccc92)); /* 54 */
    c = II(c, d, a, b, x[10], S43, uint(0xffeff47d)); /* 55 */
    b = II(b, c, d, a, x[1], S44, uint(0x85845dd1)); /* 56 */
    a = II(a, b, c, d, x[8], S41, uint(0x6fa87e4f)); /* 57 */
    d = II(d, a, b, c, x[15], S42, uint(0xfe2ce6e0)); /* 58 */
    c = II(c, d, a, b, x[6], S43, uint(0xa3014314)); /* 59 */
    b = II(b, c, d, a, x[13], S44, uint(0x4e0811a1)); /* 60 */
    a = II(a, b, c, d, x[4], S41, uint(0xf7537e82)); /* 61 */
    d = II(d, a, b, c, x[11], S42, uint(0xbd3af235)); /* 62 */
    c = II(c, d, a, b, x[2], S43, uint(0x2ad7d2bb)); /* 63 */
    b = II(b, c, d, a, x[9], S44, uint(0xeb86d391)); /* 64 */

    A += a;
    B += b;
    C += c;
    D += d;
    uint ret[4] = uint[4](A, B, C, D);
    return ret;
}

uint[16] MD5_Append(uvec4 uv4){
    uint z = uint(0);
    if ((uv4[0] & uint(0x000000FF)) == z) {
        return uint[16] ( uint(0x00000080), z, z, z, z, z, z, z, z, z, z, z, z, z, z, z );
    }
    if ((uv4[0] & uint(0x0000FF00)) == z) {
        return uint[16] ( uv4[0] & uint(0x000000FF) | uint(0x00008000), z, z, z, z, z, z, z, z, z, z, z, z, z, uint(8), z );
    }
    if ((uv4[0] & uint(0x00FF0000)) == z) {
        return uint[16] ( uv4[0] & uint(0x0000FFFF) | uint(0x00800000), z, z, z, z, z, z, z, z, z, z, z, z, z, uint(16), z );
    }
    if ((uv4[0] & uint(0xFF000000)) == z) {
        return uint[16] ( uv4[0] & uint(0x00FFFFFF) | uint(0x80000000), z, z, z, z, z, z, z, z, z, z, z, z, z, uint(24), z );
    }

    if ((uv4[1] & uint(0x000000FF)) == z) {
        return uint[16] ( uv4[0], uint(0x00000080), z, z, z, z, z, z, z, z, z, z, z, z, uint(32), z );
    }
    if ((uv4[1] & uint(0x0000FF00)) == z) {
        return uint[16] ( uv4[0], uv4[1] & uint(0x000000FF) | uint(0x00008000), z, z, z, z, z, z, z, z, z, z, z, z, uint(40), z );
    }
    if ((uv4[1] & uint(0x00FF0000)) == z) {
        return uint[16] ( uv4[0], uv4[1] & uint(0x0000FFFF) | uint(0x00800000), z, z, z, z, z, z, z, z, z, z, z, z, uint(48), z );
    }
    if ((uv4[1] & uint(0xFF000000)) == z) {
        return uint[16] ( uv4[0], uv4[1] & uint(0x00FFFFFF) | uint(0x80000000), z, z, z, z, z, z, z, z, z, z, z, z, uint(56), z );
    }

    if ((uv4[2] & uint(0x000000FF)) == z) {
        return uint[16] ( uv4[0], uv4[1], uint(0x00000080), z, z, z, z, z, z, z, z, z, z, z, uint(64), z );
    }
    if ((uv4[2] & uint(0x0000FF00)) == z) {
        return uint[16] ( uv4[0], uv4[1], uv4[2] & uint(0x000000FF) | uint(0x00008000), z, z, z, z, z, z, z, z, z, z, z, uint(72), z );
    }
    if ((uv4[2] & uint(0x00FF0000)) == z) {
        return uint[16] ( uv4[0], uv4[1], uv4[2] & uint(0x0000FFFF) | uint(0x00800000), z, z, z, z, z, z, z, z, z, z, z, uint(80), z );
    }
    if ((uv4[2] & uint(0xFF000000)) == z) {
        return uint[16] ( uv4[0], uv4[1], uv4[2] & uint(0x00FFFFFF) | uint(0x80000000), z, z, z, z, z, z, z, z, z, z, z, uint(88), z );
    }

    if ((uv4[3] & uint(0x000000FF)) == z) {
        return uint[16] ( uv4[0], uv4[1], uv4[2], uint(0x00000080), z, z, z, z, z, z, z, z, z, z, uint(96), z );
    }
    if ((uv4[3] & uint(0x0000FF00)) == z) {
        return uint[16] ( uv4[0], uv4[1], uv4[2], uv4[3] & uint(0x000000FF) | uint(0x00008000), z, z, z, z, z, z, z, z, z, z, uint(104), z );
    }
    if ((uv4[3] & uint(0x00FF0000)) == z) {
        return uint[16] ( uv4[0], uv4[1], uv4[2], uv4[3] & uint(0x0000FFFF) | uint(0x00800000), z, z, z, z, z, z, z, z, z, z, uint(112), z );
    }
    if ((uv4[3] & uint(0xFF000000)) == z) {
        return uint[16] ( uv4[0], uv4[1], uv4[2], uv4[3] & uint(0x00FFFFFF) | uint(0x80000000), z, z, z, z, z, z, z, z, z, z, uint(120), z );
    }
    return uint[16] ( uv4[0], uv4[1], uv4[2], uv4[3], z, z, z, z, z, z, z, z, z, z, uint(128), z );
}

void main(){
    gl_PointSize = 1000;
    uvec4 aaa = uvec4(uint(960051513),uint(3750201),0,0);
    //loc_uv4_text = aaa;
    uint arr[16] = MD5_Append(loc_uv4_text);    // 字节补齐
    uint md5[4] = MD5_Trasform(arr);            // 计算md5
    if(md5[0] == u_x && md5[1] == u_y && md5[2] == u_z && md5[3] == u_w){
        m_result[0] = float((loc_uv4_text.x) & uint(0x000000FF));
        m_result[1] = float((loc_uv4_text.x >> 8) & uint(0x000000FF));
        m_result[2] = float((loc_uv4_text.x >> 16) & uint(0x000000FF));
        m_result[3] = float(loc_uv4_text.x >> 24);
        
        m_result[4] = float((loc_uv4_text.y) & uint(0x000000FF));
        m_result[5] = float((loc_uv4_text.y >> 8) & uint(0x000000FF));
        m_result[6] = float((loc_uv4_text.y >> 16) & uint(0x000000FF));
        m_result[7] = float(loc_uv4_text.y >> 24);
        
        m_result[8] = float((loc_uv4_text.z) & uint(0x000000FF));
        m_result[9] = float((loc_uv4_text.z >> 8) & uint(0x000000FF));
        m_result[10] = float((loc_uv4_text.z >> 16) & uint(0x000000FF));
        m_result[11] = float(loc_uv4_text.z >> 24);
        
        m_result[12] = float((loc_uv4_text.w) & uint(0x000000FF));
        m_result[13] = float((loc_uv4_text.w >> 8) & uint(0x000000FF));
        m_result[14] = float((loc_uv4_text.w >> 16) & uint(0x000000FF));
        m_result[15] = float(loc_uv4_text.w >> 24);
        gl_Position = vec4(-1,-1,0,1);
    }else{
        gl_Position = vec4(-2,-2,0,1);
    }
}