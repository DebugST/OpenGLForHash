#version 330 core
/*
 * 当有像素需要渲染时 会执行此代码
 * 在顶点着色器没碰撞出密码时 不会有像素需要渲染
 * 当有碰撞结果时 则会触此代码
 * 因为在顶点着色器中指定了绘制点的大小 
 * 所以在左下角将会有一个正方形区域会被渲染
 * 而我们将碰撞结果写入像素行中
 */
// 此变量与顶点着色器中的同名变量关联 即:结果
varying float[16] m_result;

out vec4 fragColor; //当前像素需要输出的颜色

void main(){
    // gl_FragCoord 当前着色器输出的颜色位于显示视窗中的那个像素
    // 最终屏幕中的像素是以RGB呈现 所以我们需要6个像素来写入结果
    // 6 * 3 = 18 m_result有16个值
    int x = int(gl_FragCoord.x) * 3;
    
    if(x < 15){     // 15 = 5 * 3, 也就是前面5个像素
        fragColor = vec4(
            m_result[x] / float(255),       // R
            m_result[x + 1] / float(255),   // G
            m_result[x + 2] / float(255),   // B
            1.0);                           // A
    }else if(x == 15){
        fragColor = vec4(m_result[15] / float(255),0,0,1);
    }else{
        fragColor = vec4(0,0,1,1);          // 其他区域随便给个颜色比如蓝色
    }
}