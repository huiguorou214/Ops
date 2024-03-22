#! /bin/bash

usage()
{
	echo "Example:./hgame_dep.sh [worldid]"
    echo "paramter 1: world id"
	echo "paramter 2:"
	echo "            0 - right now"
	echo "            1 - safe restart"
}

if [ $# -lt 1 ];then
    usage
	exit -1;
fi

WORLD_ID=$1
ROLOAD_FLAG=$2

RUNTIME_USERNAME="mmog"
RUNTIME_PASSWORD="mmog"

GAME_SRC=$(cd `dirname $0`;pwd)
GAME_HOME=$(cd "$GAME_SRC/..";pwd)

game_comm_dir=$GAME_HOME/comm_release
game_cfg_dir=$GAME_HOME/cfg
game_src_dir=$GAME_HOME/src

if [ ! -d ${game_comm_dir} ] ;then
	echo "${game_comm_dir} is not exist !"
	exit;
fi
if [ ! -d ${game_cfg_dir} ] ;then
	echo "${game_cfg_dir} is not exist !"
	exit;
fi
if [ ! -d ${game_src_dir} ] ;then
	echo "${game_src_dir} is not exist !"
	exit;
fi

WORLD_PATH=
if [ $WORLD_ID = "1" ];then
	WORLD_PATH="/usr/local/mmog/world"
else
	WORLD_PATH="/usr/local/mmog/world_${WORLD_ID}/world"
fi

if [ ! -d ${WORLD_PATH} ]; then
	echo "${WORLD_PATH} is not exist !"
	exit;
fi

su -l $RUNTIME_USERNAME -c '
	rm '$WORLD_PATH'/zone/bin/zone_svr
' <<EOF
$RUNTIME_PASSWORD
EOF

#make clean;make
#zone_svr
su -l $RUNTIME_USERNAME -c '

	rm -f '$WORLD_PATH'/zone/cfg/script/*

	cp -f '${game_cfg_dir}'/res/mmogerr.xml 			            '$WORLD_PATH'/zone/cfg/res/
	cp -f '${game_cfg_dir}'/res/resdb_meta.tdr 			            '$WORLD_PATH'/zone/cfg/res/
	cp -f '${game_cfg_dir}'/op_log_meta.tdr						    '$WORLD_PATH'/zone/cfg/
	cp -f '${game_cfg_dir}'/proto_ss.tdr						    '$WORLD_PATH'/zone/cfg/
	cp -f '${game_cfg_dir}'/proto_cs.tdr						    '$WORLD_PATH'/zone/cfg/
	cp -f '${game_cfg_dir}'/db_meta/*.tdr 				            '$WORLD_PATH'/zone/cfg/db_meta/
	cp -f '${game_src_dir}'/zone/zone_svr/zone_svr 		            '$WORLD_PATH'/zone/bin/
	cp -f '${game_src_dir}'/zone/zone_conn/zone_conn 	            '$WORLD_PATH'/zone/bin/
	cp -f '${game_src_dir}'/check_src_id.sh 			            '$WORLD_PATH'/zone/bin/;
' << EOF
$RUNTIME_PASSWORD
EOF

#db
su -l $RUNTIME_USERNAME -c '
	cp -f  '${game_cfg_dir}'/db_meta/*.tdr 			                '$WORLD_PATH'/db/cfg/db_meta/;
' << EOF
$RUNTIME_PASSWORD
EOF

#tlogdb
su -l $RUNTIME_USERNAME -c '
	cp -f '${game_comm_dir}'/services/tlog_service/tlogd 			'$WORLD_PATH'/logsvr/bin/;
	cp -f '${game_comm_dir}'/services/tlog_service/logdump 			'$WORLD_PATH'/logsvr/bin/;
	cp -f '${game_src_dir}'/logdb/logdb                             '$WORLD_PATH'/logsvr/bin/;
	cp -f '${game_comm_dir}'/services/tlog_service/tconnddef.tdr 	'$WORLD_PATH'/logsvr/bin/;
	cp -f '${game_comm_dir}'/services/tlog_service/tconnddef.tdr 	'$WORLD_PATH'/logsvr/cfg/;

	cp -f '${game_comm_dir}'/services/tlog_service/*.sh  			'$WORLD_PATH'/logsvr/cfg/;
	cp -f '${game_comm_dir}'/services/tlog_service/*.xml  			'$WORLD_PATH'/logsvr/cfg/;
	cp -f '${game_comm_dir}'/services/tlog_service/*.tdr 			'$WORLD_PATH'/logsvr/cfg/;
	cp -f '${game_src_dir}'/comm/op_log_meta.tdr 					'$WORLD_PATH'/logsvr/cfg/;
' << EOF
$RUNTIME_PASSWORD
EOF

# 区一级进程拷贝 start
############################
# 以下区一级进程在183上
if [ $WORLD_ID = "1" ];then
#account
su -l $RUNTIME_USERNAME -c '
	cp -f '${game_cfg_dir}'/db_meta/*.tdr 			                /usr/local/mmog/region/cfg/db_meta/;
	cp -f '${game_cfg_dir}'/proto_cs.tdr 			                /usr/local/mmog/region/cfg/;
	cp -f '${game_src_dir}'/auth_svr/auth_svr 		                /usr/local/mmog/region/bin/;
	cp -f '${game_cfg_dir}'/dirty/dirtyword.csv			            /usr/local/mmog/region/cfg/dirty/;
	cp -f '${game_src_dir}'/dirty_svr/dirty_svr						/usr/local/mmog/region/bin/;
	cp -f '${game_src_dir}'/rank_svr/rank_svr						/usr/local/mmog/region/bin/;
	cp -f '${game_src_dir}'/match_svr/match_svr						/usr/local/mmog/region/bin/;
' << EOF
$RUNTIME_PASSWORD
EOF

#bi_svr
su -l $RUNTIME_USERNAME -c '
	cp -f '${game_cfg_dir}'/proto_ss.tdr 				            /usr/local/mmog/region/cfg/;
	cp -f '${game_cfg_dir}'/db_meta/* 			                    /usr/local/mmog/region/cfg/db_meta/;
	cp -f '${game_src_dir}'/bi_service/bi_service 		            /usr/local/mmog/region/bin/;
' << EOF
$RUNTIME_PASSWORD
EOF
fi

############################
# 区一级进程拷贝 end

# 关停 zone_svr zone_conn
# 脚本会等待zone_svr完全自然关停后再继续下文
su -l $RUNTIME_USERNAME -c '

	cd '$WORLD_PATH'/zone/cfg; 

	./stop_zone_conn_1.'$WORLD_ID'.60.1_66.sh;
	./stop_zone_svr_1.'$WORLD_ID'.61.1_66.sh;

	if [ '$ROLOAD_FLAG' ] && [ '$ROLOAD_FLAG' = "1" ]; then

		echo "writing db..."

		while true ; do
			CMD_RESULT=$(cat /tmp/zone_svr_1.'$WORLD_ID'.61.1_66.pid | xargs ps -p | grep zone_svr | wc -l)
			if [ ${CMD_RESULT} -lt 1 ]; then
				break
			fi
			sleep 1s
		done
	fi

	./stop_zone_svr_1.'$WORLD_ID'.61.1_66.sh;
	./zone_1.'$WORLD_ID'.61.1_66_rmshm.sh
' << EOF
$RUNTIME_PASSWORD
EOF

# 服一级的orm关停启动
su -l $RUNTIME_USERNAME -c '

	cd '$WORLD_PATH'/db/cfg; 

	./stop_misc_db_1.'$WORLD_ID'.32.1_66.sh;
	./stop_role_db_1.'$WORLD_ID'.30.1_66.sh;
	./start_misc_db_1.'$WORLD_ID'.32.1_66.sh;
	./start_role_db_1.'$WORLD_ID'.30.1_66.sh
' << EOF
$RUNTIME_PASSWORD
EOF

# 服一级业务进程启动
su -l $RUNTIME_USERNAME -c '

	cd '$WORLD_PATH'/zone/cfg; 

	./start_zone_conn_1.'$WORLD_ID'.60.1_66.sh;
	./start_zone_svr_1.'$WORLD_ID'.61.1_66.sh
' << EOF
$RUNTIME_PASSWORD
EOF

#服一级运营日志服务启动
su -l $RUNTIME_USERNAME -c '

	cd '$WORLD_PATH'/logsvr/cfg;

	./stop_tlogd_1.'$WORLD_ID'.31.1_66.sh;
	./stop_logdb_1.'$WORLD_ID'.33.1_66.sh
	./start_tlogd_1.'$WORLD_ID'.31.1_66.sh;
	./start_logdb_1.'$WORLD_ID'.33.1_66.sh
' << EOF
$RUNTIME_PASSWORD
EOF

# 区一级进程启停 start
############################

#	./stop_bi_service_1.0.112.1_66.sh;
#	./start_bi_service_1.0.112.1_66.sh;
# 以下区一级进程在183上
if [ $WORLD_ID = "1" ];then
# bi_svr
su -l $RUNTIME_USERNAME -c '

	cd /usr/local/mmog/region/cfg;

	./stop_auth_svr_1.0.70.1_66.sh;
	./start_auth_svr_1.0.70.1_66.sh

	./stop_dirty_svr_1.0.76.1_66.sh;
	./start_dirty_svr_1.0.76.1_66.sh

	./stop_rank_svr_1.0.77.1_66.sh;
	./start_rank_svr_1.0.77.1_66.sh

	./stop_match_svr_1.0.78.1_66.sh;
	./start_match_svr_1.0.78.1_66.sh		

' <<EOF
$RUNTIME_PASSWORD
EOF
fi