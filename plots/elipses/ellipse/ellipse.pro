pro ellips,D, musup,muinf,xinf,xsup,yinf,ysup,a,b,x0,y0,alfa,write

  reg ='D'+strcompress(string(D),/remove_al)
  readcol, '/mnt/sersic/mferraro/g3d/ellipse/sb_091/sb_091_'+reg, xx, yy, ssb
  
   ph0 = 2*!pi*randomu(seed,50)
   n = n_elements(x)

   x24_ind=where( ssb[*] lt musup and ssb[*] gt muinf and xx[*] lt xsup and yy[*] lt ysup and xx gt xinf and yy gt yinf)
   ;print, sb[x24_ind]

   x  = xx[x24_ind]
   y  = yy[x24_ind]
   sb = ssb[x24_ind]
 ; Compute weights function
   weights = 0.75/(4.0^2 + 0.1^2)

 ; Fit ellipse and plot result
 ;  p = mpfitellipse(x, y,[130.,50,0,0,150.*!pi/180.])
 ;  phi = dindgen(101)*2D*!dpi/100
 ;  plot, x, y, psym=1
 ;  oplot, p[2]+p[0]*cos(phi), p[3]+p[1]*sin(phi), color='ff'xl

 ; Fit ellipse and plot result - WITH TILT
   p = mpfitellipse(x, y,[a,b,x0,y0,alfa*!pi/180.], /tilt)
   phi = dindgen(101)*2D*!dpi/100
   ; New parameter P[4] gives tilt of ellipse w.r.t. coordinate axes
   ; We must rotate a standard ellipse to this new orientation
   xm = p[2] + p[0]*cos(phi)*cos(p[4]) + p[1]*sin(phi)*sin(p[4])
   ym = p[3] - p[0]*cos(phi)*sin(p[4]) + p[1]*sin(phi)*cos(p[4])
   window, 0, xsize=600, ysize=600
   plot, x, y, XRANGE= [-200,200], YRANGE=[-200,200], psym=2,symsize = 1.0
   oplot, xm, ym, color='ff'xl
 

   if write eq 1 then begin
     chi = 0.
     READ, chi, PROMPT='Ingresar chi-cuadrado: '
     print, 'entre a escribir'
     file_out = '/mnt/sersic/mferraro/g3d/ellipse/parametros.txt'
     get_lun, lala
     openw, lala, file_out, /APPEND
     print, format='(i6,9g15.5)',D, p[0],p[1],p[2],p[3],p[4],chi
     printf, lala, format='(i6,9g15.5)',D, p[0],p[1],p[2],p[3],p[4],chi
     close, lala

     file2 = '/mnt/sersic/mferraro/g3d/ellipse/iniciales.txt'
     get_lun, lele
     openw, lele, file2, /APPEND
     printf, lele,format='(i6,9g15.7)',D, musup, muinf, xsup, ysup, a, b, x0, y0, alfa
     close, lele
  endif

end
