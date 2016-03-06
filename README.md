#Red Eye
This hack serves as an iOS application that can serve as a simple way to potentially detect for the early stages of retinoblastoma and other optical afflictions. 
The initial plan was to gain direct control over the amber LED in an iPhone which is used as the main flash when taking pictures and use that LED separately from the normal white LED that goes off before a picture is taken normally with an iPhone.
However, Apple prevents any access to the amber LED unless it is in conjunction with the white LED preceding it, thus reducing the likelihood that the red eye effect will be present in the resulting image. 
#Future Plans
From this point on I plan on using some sort of circuit board such as a Raspberry Pi or an Arduino to build a separate flash unit that can be controlled either through a wired connection or over bluetooth in order to gain the necessary flash timing needed.
