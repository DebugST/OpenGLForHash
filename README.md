# OpenGLForHash

这是一个如何使用`OpenGL`的`渲染管线`进行`Hash碰撞`的一个`Demo`

思路是在`顶点着色器`中进行`Hash碰撞`，在`片段着色器`中通过像素的`RGB`值进行结果输出。

因为我们无法通过着色器代码向`CPU`进行传值。虽然有`uniform`但是`uniform`对于着色器代码而言是只读不可写的。

具体的实现可以查看`docs`中的`index.html`或者在线版本:[LINK](https://debugst.github.io/OpenGLForHash/)