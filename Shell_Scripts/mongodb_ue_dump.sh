#!/bin/bash

# MongoDB 连接详情
host="10.0.0.3:27017"
username="mongouser"
password="JSi22dWDS2Odlqds"
authenticationDatabase="admin"
db="boomboy"

# 要导出的集合
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

# 导出每个集合
for collection in "${collections[@]}"
do
    echo "导出集合: $collection"
    mongoexport --host "$host" -u "$username" -p "$password" --authenticationDatabase "$authenticationDatabase" --db "$db" --collection "$collection" -o "/home/boomboy.$collection.json"
done

echo "所有集合成功导出"

