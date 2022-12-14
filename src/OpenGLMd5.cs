using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using STLib.OpenGL;
using STLib.OpenGL.GL;
using STLib.OpenGL.GLFW;
using System.IO;

namespace STGL
{
    class OpenGLMd5
    {
        public static string Run(string strDic, string strTargetMd5, int nCountForFrame) {
            IntPtr window = GLFW.CreateWindow(400, 300, "OpenGLMd5", IntPtr.Zero, IntPtr.Zero);
            if (window == IntPtr.Zero) {
                Console.WriteLine("Failed to create GLFW window");
                GLFW.Terminate();
                return null;
            }
            GLFW.MakeContextCurrent(window);
            try {
                GL.Init(GLFW.GetProcAddress);
            } catch (Exception ex) {
                Console.WriteLine(ex.Message);
                GLFW.Terminate();
                return null;
            }
            int nWidth = 0, nHeight = 0;
            GLFW.GetFramebufferSize(window, ref nWidth, ref nHeight);
            GL.Viewport(0, 0, nWidth, nHeight);

            //====================================

            string strResult = string.Empty;
            byte[] b_arrs_result_buffer = new byte[18];
            uint[] u_arrs_text_buffer = new uint[nCountForFrame * 4]; // 需要送入显存的数据

            int nBufferLen = sizeof(uint) * u_arrs_text_buffer.Length;

            uint vao = GL.GenVertexArrays();    // 创建VAO，可理解为创建了一个模型对象
            GL.BindVertexArray(vao);            // 将此对象绑定到当前操作的上下文

            uint vbo = GL.GenBuffers();         // STGL对此函数进行了多个重载
            GL.BindBuffer(GL.GL_ARRAY_BUFFER, vbo); // 此buffer用于保存顶点数据
            GL.BufferData(GL.GL_ARRAY_BUFFER, nBufferLen, IntPtr.Zero, GL.GL_STREAM_DRAW_ARB);
            GL.VertexAttribPointer(0, 4, GL.GL_FLOAT, false, 4 * sizeof(uint), IntPtr.Zero);
            GL.EnableVertexAttribArray(0);

            var str_vertex_shader = System.IO.File.ReadAllText("./glsl_md5.vs", Encoding.UTF8);
            var str_fragment_shader = System.IO.File.ReadAllText("./glsl_md5.fs", Encoding.UTF8);
            var gp = GLProgram.Create(str_vertex_shader, str_fragment_shader);
            gp.Use();

            uint[] arrs_result = OpenGLMd5.Md5ToUints(strTargetMd5);
            gp.SetUniform("u_x", arrs_result[0]);
            gp.SetUniform("u_y", arrs_result[1]);
            gp.SetUniform("u_z", arrs_result[2]);
            gp.SetUniform("u_w", arrs_result[3]);
            try {
                using (StreamReader reader = new StreamReader(strDic, Encoding.UTF8)) {
                    int nCounter = 0;
                    string strLine = string.Empty;
                    while ((strLine = reader.ReadLine()) != null) {
                        OpenGLMd5.TextToBuffer(u_arrs_text_buffer, nCounter << 2, strLine);
                        if (++nCounter != nCountForFrame) {
                            continue;
                        }
                        GL.BufferSubData(GL.GL_ARRAY_BUFFER, IntPtr.Zero, u_arrs_text_buffer);
                        GL.DrawArrays(GL.GL_POINTS, 0, nCounter);
                        nCounter = 0;
                        strResult = OpenGLMd5.GetResult(b_arrs_result_buffer);
                        if (strResult != null) return strResult;
                    }
                    if (nCounter != 0) {
                        GL.BufferSubData(GL.GL_ARRAY_BUFFER, IntPtr.Zero, nCounter * 4 * sizeof(uint), u_arrs_text_buffer);
                        GL.DrawArrays(GL.GL_POINTS, 0, nCounter);
                        strResult = OpenGLMd5.GetResult(b_arrs_result_buffer);
                        if (strResult != null) return strResult;
                    }
                }
            } finally {
                GLFW.SetWindowShouldClose(window, true);
            }
            return null;
        }

        private static string GetResult(byte[] byBuffer) {
            unsafe {
                fixed (byte* ptr = &byBuffer[0]) {
                    GL.ReadPixels(0, 0, 6, 1, GL.GL_RGB, GL.GL_UNSIGNED_BYTE, (IntPtr)ptr);
                }
            }
            if (byBuffer[0] != 0) {
                return Encoding.UTF8.GetString(byBuffer).Trim('\0');
            }
            return null;
        }

        public static void TextToBuffer(uint[] buffers, int nIndex, string strText) {
            buffers[nIndex] = 0;
            buffers[nIndex + 1] = 0;
            buffers[nIndex + 2] = 0;
            buffers[nIndex + 3] = 0;
            byte[] byText = Encoding.UTF8.GetBytes(strText);
            unsafe {
                fixed (void* ptr_src = &byText[0])
                fixed (void* ptr_dst = &buffers[nIndex]) {
                    Pointer.Copy(ptr_dst, ptr_src, byText.Length < 16 ? byText.Length : 16);
                }
            }
        }

        public static uint[] Md5ToUints(string strMd5) {
            uint[] ret = new uint[4];
            byte[] by_md5 = new byte[16];
            for (int i = 0; i < 16; i++) {
                by_md5[i] = Convert.ToByte(strMd5.Substring(i << 1, 2), 16);
            }
            unsafe {
                fixed (void* ptr_src = &by_md5[0])
                fixed (void* ptr_dst = &ret[0]) {
                    Pointer.Copy(ptr_dst, ptr_src, by_md5.Length < 16 ? by_md5.Length : 16);
                }
            }
            return ret;
        }
    }
}
