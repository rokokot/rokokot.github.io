---
title: Multilingual Question Representations
dates: 2024 - Present
supervisors: Miryam de Lhoneux, Wessel Poelman
---

## Type and Complexity Signals in Multilingual Question Representations

### Project Overview

This project develops a framework for studying how multilingual language models encode different interrogative structures across 7 languages. We investigate how linguistic complexity signals are represented in embedding spaces and how they can be extracted using static word features and supervised probing techniques.

### Research Objectives

- Evaluate whether multilingual models encode meaningful representations of sentence-level properties related to question type and linguistic complexity

- Survey methods of extracting linguistic cues from supervised task performance metrics
  
- Compare traditional ML baselines with neural approaches

### Technical Implementation

The project implements a set of traditional ML baselines using a variety of linear models and ensembles, and compares performance to diagnostic models trained on top of frozen glot500 embeddings. We developed a custom dataset and designed experiments to scale efficiently on HPC infrastructure using Slurm and distributed parallel execution modules.

Technologies used include PyTorch, HF Transformers, Hydra, Submitit, Scikit-learn, and Pandas.

[View Full Project Documentation](/site/static/MQR-docs/site/index.html)