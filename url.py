import urllib
for i  in list(range(4006,4008)):
	urllib.urlretrieve("http://www.ci.gxnu.edu.cn/cbir/Corel/"+str(i)+".jpg", "C"+str(i))

