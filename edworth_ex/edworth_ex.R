
fntsz = 1.5 


cdf_exact <- function (x,ell,n) {
  cdf = pgamma( sqrt(n)*x/ell+n/ell , n, rate = ell ) ;
  return ( cdf );
}

cdf_Ed0 <- function (x,ell,n) {
  cdf = pnorm( x , mean = 0, sd = 1) ;
  return ( cdf );
}

cdf_Ed1 <- function (x,ell,n) {
  k3 = 2;
  cdf = pnorm(x,0,1) ;
  cdf = cdf -dnorm(x,0,1)*k3*(x^2-1)/6/sqrt(n);
  return ( cdf );
}

cdf_Ed2 <- function (x,ell,n) {
  k3 = 2;
  k4 = 6;
  cdf = pnorm(x,0,1);
  cdf = cdf -dnorm(x,0,1)*k3*(x^2-1)/6/sqrt(n);
  cdf = cdf - dnorm(x,0,1)*k4*(x^3-3*x)/24/n;
  cdf = cdf - dnorm(x,0,1)*k3^2*(x^5-10*x^3+15*x)/72/n;
  return ( cdf );
}



xvec = -3+6*(0:100)/100


ell_1 = 1 
n_1 = 4
Fex_1 = cdf_exact(xvec,ell_1,n_1)
Fed0_1 = cdf_Ed0(xvec,ell_1,n_1)
Fed1_1 = cdf_Ed1(xvec,ell_1,n_1)
Fed2_1 = cdf_Ed2(xvec,ell_1,n_1)
Def0_1 = abs(Fex_1-Fed0_1)
Def1_1 = abs(Fex_1-Fed1_1)
Def2_1 = abs(Fex_1-Fed2_1)


ell_2 = 1 
n_2 = 10
Fex_2 = cdf_exact(xvec,ell_2,n_2)
Fed0_2 = cdf_Ed0(xvec,ell_2,n_2)
Fed1_2 = cdf_Ed1(xvec,ell_2,n_2)
Fed2_2 = cdf_Ed2(xvec,ell_2,n_2)
Def0_2 = abs(Fex_2-Fed0_2)
Def1_2 = abs(Fex_2-Fed1_2)
Def2_2 = abs(Fex_2-Fed2_2)


ell_3 = 1 
n_3 = 100
Fex_3 = cdf_exact(xvec,ell_3,n_3)
Fed0_3 = cdf_Ed0(xvec,ell_3,n_3)
Fed1_3 = cdf_Ed1(xvec,ell_3,n_3)
Fed2_3 = cdf_Ed2(xvec,ell_3,n_3)
Def0_3 = abs(Fex_3-Fed0_3)
Def1_3 = abs(Fex_3-Fed1_3)
Def2_3 = abs(Fex_3-Fed2_3)


ps('Edg_ex.ps')

par(mfrow=c(3,2))

plot(xvec,Fex_1,type='l',col='black',
     main = 'F(x);   n=4',
     xlab='x',
     ylab='',
     cex.lab=fntsz, 
     cex.axis=fntsz, 
     cex.main=fntsz, 
     cex.sub=fntsz)
lines(xvec,Fed0_1,type='l',col='red')
lines(xvec,Fed1_1,type='l',col='blue')
lines(xvec,Fed2_1,type='l',col='green')
 legend('bottomright',
        bg="transparent",
        bty = "n",
        c('Exact','CLT','Edg_1','Edg_2'),
        lty=c(1,1,1),
        lwd=c(2.5,2.5,2.5),
        col=c('black','red','blue','green'),
        cex=fntsz) 

plot(xvec,Def0_1,type='l',col='red',
     main = expression(paste("|",F[exact](x)-F[approx](x),'|'^2)),
     xlab='x',
     ylab='',
     cex.lab=fntsz, 
     cex.axis=fntsz, 
     cex.main=fntsz, 
     cex.sub=fntsz)
lines(xvec,Def1_1,type='l',col='blue')
lines(xvec,Def2_1,type='l',col='green')
# legend('topleft',
#        bg="transparent",
#        c('CLT','Edg_1','Edg_2'),
#        lty=c(1,1,1),
#        lwd=c(2.5,2.5,2.5),
#        col=c('red','blue','green'),
#        cex=fntsz) 

plot(xvec,Fex_2,type='l',col='black',
     main = 'F(x);   n=10',
     xlab='x',
     ylab='',
     cex.lab=fntsz, 
     cex.axis=fntsz, 
     cex.main=fntsz, 
     cex.sub=fntsz)
lines(xvec,Fed0_2,type='l',col='red')
lines(xvec,Fed1_2,type='l',col='blue')
lines(xvec,Fed2_2,type='l',col='green')
# legend('topleft',
#        bg="transparent",
#        c('Exact','CLT','Edg_1','Edg_2'),
#        lty=c(1,1,1),
#        lwd=c(2.5,2.5,2.5),
#        col=c('black','red','blue','green'),
#        cex=fntsz)

plot(xvec,Def0_2,type='l',col='red',
     main = expression(paste("|",F[exact](x)-F[approx](x),'|'^2)),
     xlab='x',
     ylab='',
     cex.lab=fntsz, 
     cex.axis=fntsz, 
     cex.main=fntsz, 
     cex.sub=fntsz)
lines(xvec,Def1_2,type='l',col='blue')
lines(xvec,Def2_2,type='l',col='green')
# legend('topleft',
#        bg="transparent",
#        c('CLT','Edg_1','Edg_2'),
#        lty=c(1,1,1),
#        lwd=c(2.5,2.5,2.5),
#        col=c('red','blue','green'),
#        cex=fntsz) 

plot(xvec,Fex_3,type='l',col='black',
     main = 'F(x);   n=100',
     xlab='x',
     ylab='',
     cex.lab=fntsz, 
     cex.axis=fntsz, 
     cex.main=fntsz, 
     cex.sub=fntsz)
lines(xvec,Fed0_3,type='l',col='red')
lines(xvec,Fed1_3,type='l',col='blue')
lines(xvec,Fed2_3,type='l',col='green')
# legend('topleft',
#        bg="transparent",
#        c('Exact','CLT','Edg_1','Edg_2'),
#        lty=c(1,1,1),
#        lwd=c(2.5,2.5,2.5),
#        col=c('black','red','blue','green'),
#        cex=fntsz) 

plot(xvec,Def0_3,type='l',col='red',
     main = expression(paste("|",F[exact](x)-F[approx](x),'|'^2)),
     xlab='x',
     ylab='',
     cex.lab=fntsz, 
     cex.axis=fntsz, 
     cex.main=fntsz, 
     cex.sub=fntsz)
lines(xvec,Def1_3,type='l',col='blue')
lines(xvec,Def2_3,type='l',col='green')
# legend('topleft',
#        bg="transparent",
#        c('CLT','Edg_1','Edg_2'),
#        lty=c(1,1,1),
#        lwd=c(2.5,2.5,2.5),
#        col=c('red','blue','green'),
#        cex=fntsz) 

dev.off()



