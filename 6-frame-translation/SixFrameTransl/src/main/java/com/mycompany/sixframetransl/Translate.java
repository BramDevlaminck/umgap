/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.sixframetransl;

import java.io.File;
import java.io.InputStream;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import org.biojava.nbio.core.sequence.*;
import org.biojava.nbio.core.sequence.compound.*;
import org.biojava.nbio.core.sequence.io.*;
import org.biojava.nbio.core.sequence.template.*;
import org.biojava.nbio.core.sequence.transcription.*;
import org.biojava.nbio.core.util.*;

/**
 *
 * @author Aranka
 * 
 */
public class Translate {
    /**
     * 
     * @param args array of Strings 1. name of FastA file 2. code translation table 3. change all initiation codons to Met? 
     */
    public static void main(String[] args){
        File f = new File(args[0]);
        if ( ! f.exists()) {
            System.err.println("File does not exist " + args[0]);
            return;
        }
        int table = Integer.parseInt(args[1]);
        boolean initM = Boolean.parseBoolean(args[2]);
        try {
            InputStreamProvider isp = new InputStreamProvider();

            InputStream stream = isp.getInputStream(f);


            // define the Ambiguity Compound Sets
            AmbiguityDNACompoundSet ambiguityDNACompoundSet = AmbiguityDNACompoundSet.getDNACompoundSet();
            CompoundSet<NucleotideCompound>  nucleotideCompoundSet;
            nucleotideCompoundSet = AmbiguityRNACompoundSet.getRNACompoundSet();

            FastaReader<DNASequence, NucleotideCompound> proxy =
                    new FastaReader<>(
                            stream,
                            new GenericFastaHeaderParser<DNASequence, NucleotideCompound>(),
                            new DNASequenceCreator(ambiguityDNACompoundSet));

            // has only one entry in this example, but could be easily extended to parse a FASTA file with multiple sequences
            LinkedHashMap<String, DNASequence> dnaSequences = proxy.process();

            // Initialize the Transcription Engine
            TranscriptionEngine engine = new
                    TranscriptionEngine.Builder().dnaCompounds(ambiguityDNACompoundSet).table(table).initMet(initM).trimStop(true).translateNCodons(true).rnaCompounds(nucleotideCompoundSet).build();

            Frame[] sixFrames = Frame.getAllFrames();
            Iterator<String> it = dnaSequences.keySet().iterator(); 
            while(it.hasNext()) {
                String FastaHeader = it.next();
                Map<Frame, Sequence<AminoAcidCompound>> results;
                results = engine.multipleFrameTranslation(dnaSequences.get(FastaHeader), sixFrames);
                for (Frame frame : sixFrames){
                    System.out.println(">" + FastaHeader + "|Frame:" + frame);
                    System.out.println(results.get(frame));
                }
            }
        } catch (Exception e){
            e.printStackTrace();
        }
    }
}
