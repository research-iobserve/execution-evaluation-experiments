## Execution of Evaluation Experiments

This repository contains PCM models of the JPetstore to evaluate the execution of system adaptations on a kubernetes cluster. It contains the following artifacts:

* The **kubernetes** folder contains different kubernetes configurations for different scenarios. They are used to create an initial JPetStore deployment.
* The **iobserve** folder contains dummy configuration files for iObserve's planning, adaptation, and execution services. These files contain placeholders for concrete paths.
* The **scenarios** folder contains a runtime and a redeployment model for each evaluated adaptation scenario as they would result from iObserve's planning phase. The further represents the JPetStore's present architecture and the latter represents its intended architecture. The included correspondence model maps the PCM model components to the deployable images.

A number of scripts can be used to execute the evaluation. We recommend to use `watch kubectl get <target>` to watch `services`, `deployments`, and `pods` while executing the different scripts. Before executing the evaluation scripts take a look at the config file:
* Use the **config** file to set the paths to your working directory and docker repository they differ from the preset values. Set the `SCENARIO` variable to choose the scenario you want to execute. Currently migration, replication, and dereplication are possible scenarios.

The following scripts are included and should be executed in the given order:
1. **startup-kube-jpetstore.sh** depending on the scenario from the config file it creates an initial JPetStore deployment.
2. **iobserve-setup** sets up the working directories of the different services, creates configuration files with concrete paths instead of placeholders, and modifies the planning's main method to mock the actual planning and just send out predefined models. Depending on the scenario runtime and redeployment models are inserted to the planning's working directory.
3. **iobserve-run-all** starts planning, adaptation, and execution services and finishes them after a given time. The planning service will send out the models from its working directory.
4. **shutdown-kube-jpetstore** terminates the deployed kubernetes instances.

As an alternative to the **iobserve-run-all** you can use the following scripts:
* **iobserve-run-planning**, **iobserve-run-adaptation**, and **iobserve-run-execution** can be used to start the different services indepentently.
* **iobserve-setup-planning** can be used to (re)configure only the planning service while adaptation and execution keep running. Before reconfiguring the planning service a new scenario may be chosen by editing the config file.
