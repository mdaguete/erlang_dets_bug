# erlang_dets_bug


After upgrading a project from R14B03 to R16B01 we've found that dets files are growing constanly after delete operations.
In previous version the empty space was reused to allocate new data, in R16B01 seems that empty space isn't reused.

## Test

To test the bug clone the project and then ``make test``, it will print the results file size and object stored after the
following instructions:

* Create an empty file.
* Store 10 x 500 kb objects.
* Print size and object number.
* Empty the file 
* Print size and object number.
* Reload 10 x 500 kb objects.
* Print size and object number.
* Empty all
* Print again

In R14B04 the file size is constant.
 
~~~~

OTP Version "R14B04"
DETS info for dets_test after 10:
  File Size: 5756255
	Number Objects Stored: 10
DETS info for dets_test after "emptied":
	File Size: 5756255
	Number Objects Stored: 0
DETS info for dets_test after "reloaded":
	File Size: 5756255
	Number Objects Stored: 10
DETS info for dets_test after "last emptied":
	File Size: 5756255
	Number Objects Stored: 0
  
~~~~


In R15B03 too .. 


~~~

OTP Version "R15B03"
DETS info for dets_test after 10:
  File Size: 5236063
	Number Objects Stored: 10
DETS info for dets_test after "emptied":
	File Size: 5236063
	Number Objects Stored: 0
DETS info for dets_test after "reloaded":
	File Size: 5236063
	Number Objects Stored: 10
DETS info for dets_test after "last emptied":
	File Size: 5236063
	Number Objects Stored: 0
  
~~~~

In R16B the bug appears

~~~

OTP Version "R16B"
DETS info for dets_test after 10:
  File Size: 6272382
	Number Objects Stored: 10
DETS info for dets_test after "emptied":
	File Size: 6272382
	Number Objects Stored: 0
DETS info for dets_test after "reloaded":
	File Size: 12051807
	Number Objects Stored: 10
DETS info for dets_test after "last emptied":
	File Size: 12576095
	Number Objects Stored: 0

~~~

The same for R16B01

~~~
OTP Version "R16B01"
DETS info for dets_test after 10:
  File Size: 5236063
	Number Objects Stored: 10
DETS info for dets_test after "emptied":
	File Size: 5236063
	Number Objects Stored: 0
DETS info for dets_test after "reloaded":
	File Size: 11003231
	Number Objects Stored: 10
DETS info for dets_test after "last emptied":
	File Size: 11527519
	Number Objects Stored: 0
~~~

