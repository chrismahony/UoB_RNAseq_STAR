include { FASTQC } from '../modules/fastqc'
include { STAR_ALIGN } from '../modules/star_align'
include { FEATURECOUNTS } from '../modules/featurecounts'
include { MULTIQC } from '../modules/multiqc'

workflow RNASEQ {
    // Define channels based on params
     reads_ch = Channel
        .fromFilePairs(params.reads, checkIfExists: true)
        .map { name, files -> 
            def sampleName = name.split('_').take(2).join('_')
            return tuple(sampleName, files)
        }
        .groupTuple()
        .map { sampleName, filesList -> 
            return tuple(sampleName, filesList.flatten())
        }
    

    genome_dir = file(params.genome_dir)
    gtf_file = file(params.gtf_file)
    multiqc_config_file = file(params.multiqc_config)

    // Run FASTQC on all samples
    FASTQC(reads_ch)
    
    // Run STAR alignment
    STAR_ALIGN(reads_ch, genome_dir, gtf_file)

    // Collect all BAM files    
    all_bams = STAR_ALIGN.out.bam.map { it -> it[1] }.collect()

    // Run featureCounts on all BAM files at once
    FEATURECOUNTS(all_bams, gtf_file)
      
    // Debug step
    println "MultiQC config: ${params.multiqc_config ? multiqc_config_file : 'No config provided'}"

     
    // Collect FastQC outputs
    ch_fastqc_outputs = FASTQC.out.fastqc_results.map { meta, files -> files }.flatten().collect()

    // MultiQC config file
    ch_multiqc_config = Channel.fromPath(params.multiqc_config, checkIfExists: true)

    // Run MultiQC on FastQC outputs
    MULTIQC(ch_multiqc_config, ch_fastqc_outputs)


}
