for file in /pscratch/sd/m/mm3553/data/GB_32768_32768_cuda/*; do
    python python/check_output.py "$file" /pscratch/sd/m/mm3553/data/GB_32768_32768.magdir.bin 32768 32768;
done