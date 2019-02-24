#!/bin/bash
#Descript:SHELL应用实战联系--学生成绩管理小程序
#Version:V10
#Author:JQ_Gao

PRE_IFS=$IFS
IFS=$'\n'
############################################################
#初始界面子程序
init(){
clear
echo -e "\033[33m\033[101m
##########################################
#        1:search a record               #
#        2:add a record                  #
#        3:delete a record               #
#        4:display all record            #
#        5:edit record with vi           #
#        H:help screen                   #
#        Q:exit pragma                   #
##########################################"
echo -e "\033[32m\033[40m"
read -p "please enter your choice [1 2 3 4 5 H Q]:" val_in
}

#1搜索记录 界面子程序
fun_search(){
echo -e "\033[37m"
#在模式1输入空值时flag_1置1,使界面停留并不清屏
[ $flag_1 -eq 0 ] && clear
read -p "please enter name >>>" val_sech
}

#2添加记录 界面子程序
fun_add(){
echo -e "\033[37m"
if [ $flag_2 -eq 0 ];then
  clear 
  read -p "enter name and score of a record:" val_add
else
#模式2输入空值时flag_2置1,使界面停留并不清屏
  read -p "please enter name and score:" val_add 
fi
}

#3删除单条记录
fun_delete(){
  echo -e "\033[37m"
  read -p "please enter the number you want to delete：" val_del
}

#4列出所有记录 子程序
fun_display(){
  echo -e "\033[37m"
  cat -n /record
}

#5vi编辑记录 子程序
fun_vi(){
  vim /record
}

#H帮助界面 界面子程序
fun_help(){
  clear
  echo -e "\033[36m"
  echo "This is a student's record manager program"
}

#Error输入 子程序
fun_error(){
  echo -e "\033[31m"
  echo "please enter valid mode"
}

#No record 子程序
no_record(){
if [ ! -f /record ];then
  echo -e "\033[31m"
  echo "No record!"
  sleep 3
  continue
fi
}


############################################################
#变量初始化
flag_1=0
flag_2=0
flag_3=0

############################################################
#主程序
while :
do
[ $flag_1 -eq 0 ] && [ $flag_2 -eq 0 ] && [ $flag_3 -eq 0 ] && init
case $val_in in
1)
  no_record
  fun_search
  if [ -z $val_sech ];then
    echo "you didn't enter a name"
    flag_1=1
  elif [ ! -f /record ];then
    echo "you must have some scores before you can search!"
    sleep 5 && flag_1=0 
  elif grep -i $val_sech /record > /dev/null;then
    grep -i $val_sech /record
    sleep 3 && flag_1=0 
  else
    echo "name not in record"
    sleep 1 && flag_1=0 
  fi
  ;;
2)
  fun_add
  if [ -z $val_add ];then
    echo "you didn't enter any value"
    flag_2=1
  else
    echo $val_add >> /record
    echo "added  \"$val_add\"  in record"
    sleep 3 && flag_2=0 
  fi
  ;;
3)
  no_record
#为了避开$val_del为空值
  [ $flag_3 -eq 0 ] && fun_display 
  fun_delete
  flag_3=1
  if [ ! -z $val_del ];then
    del_text=`sed -rn "${val_del}p" /record`
    sed -ri "${val_del}d" /record 
    echo "\"$del_text\" 删除成功" && sleep 3 && flag_3=0
  fi
  ;;
4)
  no_record
  fun_display && sleep 3 
  ;;
5)
  no_record
  fun_vi 
  ;;
H)
  fun_help && sleep 3 
  ;;
Q)
  echo -e "\033[0m" && clear && exit
  ;;
*)
  fun_error && sleep 3 
esac 
done
IFS=$PRE_IFS
