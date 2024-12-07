process STAR_ALIGN {

     beforeScript '''\
        module purge; module load bluebear
        module load bear-apps/2022b
        module load STAR/2.7.11a-GCC-12.2.0
     '''.stripIndent()

    publishDir "${params.outdir}/star", mode: 'copy'

    time '20h'
    cpus 40	
    memory { 100.GB * task.attempt }

    tag "STAR on $sample_id"
    
    input:
    tuple val(sample_id), path(reads)
    path genome_dir
    path gtf_file

    output:
    tuple val(sample_id), path("${sample_id}.Aligned.sortedByCoord.out.bam"), emit: bam
    path "${sample_id}.Log.final.out", emit: log

    script:
    def readList = reads.collect{ it.toString() }
    def read1 = readList.findAll{ it.contains("_1.fq.gz") }.join(',')
    def read2 = readList.findAll{ it.contains("_2.fq.gz") }.join(',')
    """
    module purge; module load bluebear
    module load bear-apps/2022b
    module load STAR/2.7.11a-GCC-12.2.0
    
    STAR --runThreadN ${task.cpus} \
         --genomeDir $genome_dir \
         --readFilesIn $read1 $read2 \
         --readFilesCommand zcat \
         --outFileNamePrefix ${sample_id}. \
         --outSAMtype BAM SortedByCoordinate \
         --sjdbGTFfile $gtf_file
    """
}