## Windows

### Re-target the Windows SDK
If you see these types of errors:

  ![](re-target-errors.jpeg)

This is because the template project was created in an older version of Visual Studio. To fix:

  * **Right** click on **every project**
  * select **Retarget Projects**
  * click **Ok**. 
  * Next, **rebuild** the project.

If you create a new project in the future you will need to repeat these steps.