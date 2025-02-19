

 • I = λx.x                    | Ix = x 
 • K = λx.λy. x                | Kxy = x 
 • S = λx.λy.λz. x z (y z)     | Sxyz = xz(yz)
 • SKK is exactly I             


 η (eta) conversion: 
 If M is a λ-expression in which there is no free occurrence of x, then λx.Mx 
 can be replaced by M. 
 This is a rather rare conversion. 
    For example: λx.((λy. + 1 y) x) → λy. + 1 y


-----------------------------------------------------------------------

(λf. λy. f (f y)) (λx. + x x) 3         //mark N = (λx. + x x) + Beta
(λy. N (N y)) 3                         //Beta
N (N 3)                                 //Unmark
(λx. + x x) ((λx. + x x) 3)             //Beta
(λx. + x x) (+ 3 3)                     //Delta
(λx. + x x) 6                           //Beta
+ 6 6                                   //Delta
12                                      //Done
-----------------------------------------------------------------------

SKK 
(λx.λy.λz. x z (y z))KK                 //Beta
(λy.λz. K z (y z))K                     //Beta
λz. K z (K z)               
λz. (λx.λy. x) z (K z)                  //Beta
λz. (λy. z) (K z)                       //Beta
λz. z 
-----------------------------------------------------------------------

SI2(λx. + x 1)                          //exactly like ((MN)p)Q
(λx.λy.λz.xz(yz))I2(λx. + x 1)          //Beta
(λy.λz.Iz(yz))2(λx. + x 1)              //Beta
(λz.Iz(2 z))(λx. + x 1)                  //Beta
(λz.z(2 z))(λx. + x 1)                   //Beta
(λx. + x 1)(2(λx. + x 1))               //Beta
(λx. + x 1)(2 + 1)                      //Delta
(λx. + x 1)(3)                          //Beta
+ 3 1                                   //Delta
4                                       //Done
------------------------------------------------------------------------

(λx.(λx.(xx λx.x)λx.x)x)((λx.x)x)       //Alpha
(λm.(λk.(kk λc.c)λb.b)m)((λa.a)x)       //Beta
(λm.(λk.(kk λc.c)λb.b)m)x               //Beta
(λk.(kk λc.c)λb.b)x                     //Beta
(xx λc.c)λb.b                           //Done
------------------------------------------------------------------------

a. Given the following definitions:
A = λx.λy.λz.xzy
B = λx.λy.y
Show that ABABA = AA

ABABA
(λx.λy.λz.xzy)BABA                       //Beta
(λy.λz.Bzy)ABA                           //Beta
(λz.BzA)BA                               //Beta
(BBA)A                                   
((λx.λy.y)BA)A                           //Beta
((λy.y)A)A                               //Beta
AA 
------------------------------------------------------------------------

SKISKK
(λx.λy.λz.xz(yz))KISKK                   //Beta
λy.λz.Kz(yz)ISKK                         //Beta
(λz.Kz(Iz))SKK  ----.                    //Ix = x
(λz.Kzz)I           |                    //Kxy = x
(λz.z)I             |                    //Beta
I                   |
                    |
(λz.Kz(Iz))SKK    <-'                     
(λz.z)SKK                                //Beta
(S)KK                   
(λx.λy.λz.xz(yz))KK                     
(λy.λz.Kz(yz))K                          //Beta
λz.Kz(Kz)                                //Beta
λz.z                                     //Beta + Kxy = x
I
------------------------------------------------------------------------

SII(SII)
(λx.λy.λz.xz(yz))II(SII)                 //Beta
(λy.λz.Iz(yz))I(SII)                     //Beta
(λz.Iz(Iz))(SII)                         //Ix = x
(λz.zz)(SII)                             //Beta
SII(SII)                                 //...
------------------------------------------------------------------------

exersices: 

1. (λx. (x (x (y z))) x) (λu.u v)
2. (λx. (x x) y) (λy.y z)
3. (λx.λy.xyy)(λu.uyx)
4. (λx.λy.x) (λx.x) ( (λx.xx) (λx.xx) ) (λx.+ 1 x)

------------------------------------------------------------------------

(λx. (x (x (y z))) x) (λu.u v)      //mark (λu.u v) = m 
(m (m (y z))) m         
(m ((λu.u v)(y z))) m               //Beta
(m ((y z) v)) m                      
((λu.u v)((y z) v)) m               //Beta
(((y z) v) v) m                     
((y z) v) v (λu.u v)                //Done
------------------------------------------------------------------------

(λx. (x x) y) (λy.y z)          //mark (λy.y z) = m
(λx. (x x) y) m
(m m) y 
((λy.y z) m) y
(m z) y
((λy.y z) z) y
(zz)y 
zzy
------------------------------------------------------------------------

(λx.λy.xyy)(λu.uyx)           //mark (λu.uyx) = m
(λx.(λy.xyy)) m               //Beta
(λy.xyy)            

------------------------------------------------------------------------

(λx.λy.x) (λx.x) ( (λx.xx) (λx.xx) ) (λx.+ 1 x)
(λy.(λx.x)) ( (λx.xx) (λx.xx) ) (λx.+ 1 x)   // Beta 
(λx.x) (λx.+ 1 x)                            // Beta 
(λx.+ 1 x)                                   // Beta 
------------------------------------------------------------------------

(λx. λy. x y)(λw. (λx.x w) a w) b          //Beta
(λy. ((λw. (λx.x w) a w)) y) b             //Beta
((λw. (λx.x w) a w)) b                     //Beta
(λx.x b) a b                               //Beta
(a b) b                                    //Done