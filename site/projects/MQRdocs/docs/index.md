# Type and Complexity Signals in Multilingual Question Representations:

## A Diagnostic Study with Selective Control Tasks

This notebook documents the research for a master thesis evaluating the performance of multilingual transformer models (glot500) on the task of question type classification and sentence complexity regression. In this research project, we develop a framework for quantifying question complexity in a cross-lingual system setting. We begin by adressing a significant lack of unified approaches to computational modelling of linguistic complexity measures, as well as the lack of research investigating language agnostic features of information seeking linguistic structures (questions). By investigating how sentence complexity affects model performance across languages, our work contributes to the growing field of multilingual NLP evaluation, and develops a set of resources that can improve practical NLP system development.

### Project Overview

This project develops a framework for analyzing linguistic complexity signals in question representations and how they vary across languages. By implementing both traditional ML baselines and neural probing methods, we can evaluate the encoding of abstract linguistic properties in model embeddings.

### Key Research Questions

- How do different languages encode question structures in embedding spaces?
- What linguistic complexity signals can be extracted from these embeddings?
- How do traditional ML approaches compare to neural probing methods?
- Can we develop more efficient and accurate diagnostic models?

### Dataset

Our custom dataset includes question samples from 7 languages, annotated for:

- Question type (yes/no, wh-questions, etc.)
- Syntactic complexity metrics
- Semantic properties
- Language-specific features

### Implementation

The project is implemented using:

- PyTorch for neural network models
- Hugging Face Transformers for pre-trained embeddings
- Hydra for configuration management
- Submitit for distributed execution
- Scikit-learn for baseline models
- Pandas for data processing

#### Getting Started

To get started with the project:

1. The paper can be found [here](paper/paper.md)
2. Check out the [Experiments](/experiments/overview) section for details on our methodology
3. Review the [Data](/data/data_overview) documentation to understand the labels and value distribution


