#!/bin/bash

# MongoDB 连接详情
mongodb_host="10.0.0.12:27017"
mongodb_username="mongouser"
mongodb_password="t1XgxPEcl6uykbfE"
authenticationDatabase="admin"
db_name="boomboy_ue"
json_files_dir="/home"

# 定义要导入的集合及其对应的 JSON 文件
collections=(
    "RoleData"
    "AffInvite"
    "CalabashLadderRank"
    "CalabashLadderRankLog"
    "Chicken"
    "ChickenRank"
    "ChickenStepAvg"
    "Clan_Boss"
    "Clan_Chicken"
    "Clan_Legion"
    "ClanBossLog"
    "ClanChicken"
    "ClanChickenHome"
    "ClanIdCounter_Legion"
    "ClanRankLog"
    "ClanVisit"
    "CltData"
    "DailyBlockData"
    "DailyHeroRoadData"
    "DragonLandRole"
    "Global"
    "Ladder"
    "LadderRank"
    "LadderRankLog"
    "PworldData"
    "RankLog"
    "RoleBox"
    "RoleClanMap_Boss"
    "RoleClanMap_Chicken"
    "RoleClanMap_Legion"
    "Room"
    "Visit"
    "WarCollege"
    "WorldBossRank"
)

# 导入每个集合的数据
for collection_name in "${collections[@]}"
do
    file_path="$json_files_dir/boomboy.$collection_name.json"
    echo "导入集合: $collection_name"
    mongoimport --host "$mongodb_host" -u "$mongodb_username" -p "$mongodb_password" --authenticationDatabase "$authenticationDatabase" --db "$db_name" --collection "$collection_name" --file "$file_path"
done

echo "所有集合数据成功导入"

