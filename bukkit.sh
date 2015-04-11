#!/bin/bash

# DEFINE DIRECTORIOS
CRAFTDIR=/home/craft/craftbukkit
BKUPDIR=/home/btsync/MineBackup



# FUNÇÕES
function parar {
        echo "Stoping server..."
        screen -R minecraft -X stuff "stop $(printf '\r')"
        sleep 20
}

function iniciar {
        echo "Starting server..."
        bash $CRAFTDIR/craftbukkit.sh
        sleep 20
}

function gravar {
        echo "Saving progress..."
        screen -R minecraft -X stuff "save-all $(printf '\r')"
        sleep 10
        echo Save completed.
}


# AO DETECTAR OS PARAMETROS...
if [ "$1" = "reporbackup" ]; then
        ls -tlh $BKUPDIR |head -14
        echo -n "Please write down the file with the desired date:  "
        read BKUP_FILE
        echo $BKUP_FILE
        if [ ! -f $BKUPDIR/$BKUP_FILE ]; then
                echo "File not found!"
        else
                echo -n "File exists! Are you sure you want to replace the existing progress with the backup data? All progress will be lost  (y/n):  "
                read SURE
                if [ "$SURE" = "y" ]; then
                        screen -d minecraft
                        parar
                        mkdir $BKUPDIR/tmp
                        tar  -C $BKUPDIR/tmp -xvf $BKUPDIR/$BKUP_FILE && rm -rf $CRAFTDIR/world_nether $CRAFTDIR/world_the_end $CRAFTDIR/world
                        mv $BKUPDIR/tmp/* $CRAFTDIR/
                        rm -rf $BKUPDIR/tmp
                        echo "Recovery successful."
                        iniciar
                else
                        echo "Recovery canceled "
                fi
        fi

elif [ "$1" = "restart" ]; then
        echo Begining restart procedures...
        screen -d minecraft
        screen -R minecraft -X stuff "say Server is going DOWN. SAVING.. $(printf '\r')"
        gravar
        parar
        iniciar
        echo Restart completed.


elif [ "$1" = "backup" ]; then
        screen -d minecraft
        screen -R minecraft -X stuff "say Backup started! Save OFF! $(printf '\r')"
        screen -R minecraft -X stuff "save-off $(printf '\r')"
        gravar

        cd $BKUPDIR
        rm -f minecraft.tar.gz.24
        mv minecraft-day23.tar.gz minecraft-day24.tar.gz
        mv minecraft-day22.tar.gz minecraft-day23.tar.gz
        mv minecraft-day21.tar.gz minecraft-day22.tar.gz
        mv minecraft-day20.tar.gz minecraft-day21.tar.gz
        mv minecraft-day19.tar.gz minecraft-day20.tar.gz
        mv minecraft-day18.tar.gz minecraft-day19.tar.gz
        mv minecraft-day17.tar.gz minecraft-day18.tar.gz
        mv minecraft-day16.tar.gz minecraft-day17.tar.gz
        mv minecraft-day15.tar.gz minecraft-day16.tar.gz
        mv minecraft-day14.tar.gz minecraft-day15.tar.gz
        mv minecraft-day13.tar.gz minecraft-day14.tar.gz
        mv minecraft-day12.tar.gz minecraft-day13.tar.gz
        mv minecraft-day11.tar.gz minecraft-day12.tar.gz
        mv minecraft-day10.tar.gz minecraft-day11.tar.gz
        mv minecraft-day9.tar.gz minecraft-day10.tar.gz
        mv minecraft-day8.tar.gz minecraft-day9.tar.gz
        mv minecraft-day7.tar.gz minecraft-day8.tar.gz
        mv minecraft-day6.tar.gz minecraft-day7.tar.gz
        mv minecraft-day5.tar.gz minecraft-day6.tar.gz
        mv minecraft-day4.tar.gz minecraft-day5.tar.gz
        mv minecraft-day3.tar.gz minecraft-day4.tar.gz
        mv minecraft-day2.tar.gz minecraft-day3.tar.gz
        mv minecraft-day1.tar.gz minecraft-day2.tar.gz
        mv minecraft-day0.tar.gz minecraft-day1.tar.gz

        cd $CRAFTDIR
        tar -cf $BKUPDIR/minecraft-day0.tar.gz world world_nether world_the_end

        screen -R minecraft -X stuff "save-on $(printf '\r')"
        screen -R minecraft -X stuff "say Backup completed! Save ON! $(printf '\r')"

else
        echo "No valid arguments! USAGE: reporbackup|backup|restart . Eg: './Mine restart'"

fi
