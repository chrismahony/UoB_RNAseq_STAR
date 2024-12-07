process FEATURECOUNTS {
    beforeScript '''\
        module purge; module load bluebear
        module load bear-apps/2022a
        module load Subread/2.0.4-GCC-11.3.0
    '''.stripIndent()

    time '20h'
    cpus 40
    memory { 100.GB * task.attempt }

    tag "featureCounts on all samples"
    publishDir "${params.outdir}/featurecounts", mode: 'copy'

    input:
    path bams
    path gtf

    output:
    path "all_samples.counts.txt", emit: counts
    path "all_samples.counts.txt.summary", emit: summary

    script:
    """
    featureCounts -p \
        -a ${gtf} \
        -o all_samples.counts.txt \
        -T ${task.cpus} \
        ${bams}
    """
}