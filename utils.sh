# the following is meant to be used in a controlled way, line-by-line - not as a wholesale script to just run through
# extract the transcription only from the Amazon transcribe json

# in order to split files into 1k chunks;
# the resulting files will be located in directories named <file>.dir
# TODO: output directories should be in a parallel directory to not mess up the original
# TODO: output files to be named *.txt
for f in ../*.txt; do mkdir $f.dir; split -b1k $f; mv * $f.dir; done

for f in *.json; do cat $f|jq '.results.transcripts.[0].transcript' > $f.txt;done

# change name of all files from *.json.txt to *.txt
for f in *.json.txt;do mv $f `echo $f|cut -d"." -f1,3`;done

# split the text files into 1k chunks
cd split 
for f in ../*.txt; do mkdir $f.dir; split -b1k $f; mv * $f.dir; done
cd ..

# insert speaker name in the beginning of each file:
# we make xaa exempt, since we're sure Lex is the speaker there
for d in *.dir; do cd $d
mv xaa ..
echo $PWD|cut -d"/" -f6|cut -d"." -f1|cut -d"_" -f3,4|tr "_" " "|read -r spkr 
for f in *
do echo $spkr: > $f.txt
cat $f >> $f.txt
rm $f
done
mv ../xaa ./xaa.txt
cd ..
done