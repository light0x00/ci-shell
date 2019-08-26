# 此脚本的STDOUT将会作为部署后,运行应用的脚本.
echo "screen -S $app_name -X quit ;"
echo "screen -dmS $app_name java -jar $compile_output_path"
