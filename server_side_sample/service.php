<?php
include('db_connect.php');
if(isset($_POST['process']) || isset($_POST['submitData']) || isset($_POST['selectedId']) || isset($_POST['userId'])) {
  $transaction = new dbtransaction();

  $process = $transaction->escapeSpecialCharacters(trim($_POST['process']));
  $submit_data = $_POST['submitData'];
  $selected_id = $transaction->escapeSpecialCharacters(trim($_POST['selectedId']));
  $user_id = $transaction->escapeSpecialCharacters(trim($_POST['userId']));
  //$user_id = "277E3298-853F-4EC3-9E23-DCEC4B2C4B90";
  $tcu_latitude = 32.7095;
  $tcu_longitude = -97.3628;
  //$settimezonequery="SET time_zone = 'US/Central'";
  //$transaction->submitdata($settimezonequery);

  if($process == "verification"){
    $countidquery="SELECT COUNT(id) FROM user_ids WHERE user_id = '$user_id' AND phone_number IS NOT NULL";
    $idfetchedlist = $transaction->fetchtablelist($countidquery);
    $transaction->sendResponse(200, json_encode($idfetchedlist));
  }
  if($process == "firsttimeuser"){
    $countidquery="SELECT COUNT(id) FROM user_ids WHERE user_id = '$user_id'";
    $idfetchedlist = $transaction->fetchtablelist($countidquery);
    if($idfetchedlist[0][0]==0){
      $insertidquery="INSERT INTO user_ids (user_id, open_time) VALUES ('$user_id', NOW())";
      $transaction->submitdata($insertidquery);
      /*
      $last_id_query="SELECT LAST_INSERT_ID();";
      $last_id_array = $transaction->fetchtablelist($last_id_query);
      $last_id = $last_id_array[0][0];
      $insertfirstfavoritequery="INSERT INTO favorites (class_id, user_id_id) VALUES ('405','$last_id')";
      $transaction->submitdata($insertfirstfavoritequery);

      $idquery = "SELECT id FROM user_ids WHERE user_id = '$user_id'";
      $idlist = $transaction->fetchtablelist($idquery);
      $insertfirstfavoritequery="INSERT INTO favorites (class_id, user_id_id) VALUES (405, {$idlist[0][0]})";
      $transaction->submitdata($insertfirstfavoritequery);
      */
    }
  }
  else if($process == "enterphonenumber"){
    //input: submit_data, user_id
    //output:
    $submit_data_phonenumber = $submit_data['phonenumber'];
    $submit_data_email = $submit_data['emailaddress'];
    $insertphonequery="UPDATE user_ids SET phone_number = '$submit_data_phonenumber', email_address = '$submit_data_email', signup_time = NOW() WHERE user_id = '$user_id'";
    $transaction->submitdata($insertphonequery);
  }
  else if($process == "fetchmyquestions"){
    //input: user_id
    //output: id, question, date, views, location, votes, class, messagecount, imageDirectory
    $query="SELECT questions.id, questions.question, questions.date, questions.views, questions.latitude, questions.longitude, questions.votes, questions.class_id FROM questions
    JOIN user_ids ON user_ids.id = questions.user_id_id
    WHERE user_ids.user_id='$user_id' AND questions.delete_status = '0' ORDER BY questions.date DESC";
    $fetchedlist = $transaction->fetchtablelist($query);
    for($listcount=0; $listcount<count($fetchedlist); $listcount++){
      $id = $fetchedlist[$listcount][0];
      $class_id = $fetchedlist[$listcount][7];
      $time = strtotime($fetchedlist[$listcount][2]);
      $fetchedlist[$listcount][2] = date("m/d/y g:i A", $time);
      $fetchedlist[$listcount][4] = $transaction->getDistanceBetweenPointsNew($fetchedlist[$listcount][4], $fetchedlist[$listcount][5], $tcu_latitude, $tcu_longitude);
      $fetchedlist[$listcount][5] = $fetchedlist[$listcount][6];
      $classquery="SELECT class FROM classes WHERE id='$class_id'";
      $fetchedclass = $transaction->fetchtablelist($classquery);
      $fetchedlist[$listcount][6] = $fetchedclass[0][0];
      $messagecountquery="SELECT COUNT(id) FROM messages WHERE question_id='$id'";
      $fetchedmessagecount = $transaction->fetchtablelist($messagecountquery);
      $fetchedlist[$listcount][7] = $fetchedmessagecount[0][0];
      $imagequery="SELECT COUNT(id) FROM image_directories WHERE type_id='$id' AND type = 'question'";
      $fetchedimage = $transaction->fetchtablelist($imagequery);
      if($fetchedimage[0][0]!=0){
        $imagequery="SELECT directory FROM image_directories WHERE type_id='$id' AND type = 'question'";
        $fetchedimage = $transaction->fetchtablelist($imagequery);
        $fetchedlist[$listcount][8] = "http://www.".substr($fetchedimage[0][0],15);
      }
    }
    $transaction->sendResponse(200, json_encode($fetchedlist));
  }
  else if($process == "fetchmymessages"){
    //input: user_id
    //output: id, message, date, location, votes, imageDirectory
    $query="SELECT messages.id, messages.message, messages.date, messages.latitude, messages.longitude, messages.votes FROM messages
    JOIN user_ids ON user_ids.id = messages.user_id_id
    WHERE user_ids.user_id='$user_id' AND messages.delete_status = '0' ORDER BY messages.date DESC";
    $messagelist = $transaction->fetchtablelist($query);
    for($listcount=0; $listcount<count($messagelist); $listcount++){
      $id = $messagelist[$listcount][0];
      $time = strtotime($messagelist[$listcount][2]);
      $messagelist[$listcount][2] = date("m/d/y g:i A", $time);
      $messagelist[$listcount][3] = $transaction->getDistanceBetweenPointsNew($messagelist[$listcount][3], $messagelist[$listcount][4], $tcu_latitude, $tcu_longitude);
      $messagelist[$listcount][4] = $messagelist[$listcount][5];
      unset($messagelist[$listcount][5]);
      $imagequery="SELECT COUNT(id) FROM image_directories WHERE type_id='$id' AND type = 'message'";
      $fetchedimage = $transaction->fetchtablelist($imagequery);
      if($fetchedimage[0][0]!=0){
        $imagequery="SELECT directory FROM image_directories WHERE type_id='$id' AND type = 'message'";
        $fetchedimage = $transaction->fetchtablelist($imagequery);
        $messagelist[$listcount][5] = "http://www.".substr($fetchedimage[0][0],15);
      }
    }
    $transaction->sendResponse(200, json_encode($messagelist));
  }
  else if($process == "messagecontext"){
    //input: selected_id(message id)
    //output: question_id
    $messagecontextquery="SELECT question_id FROM messages WHERE id = '$selected_id' AND delete_status = '0' ORDER BY date DESC";
    $messagecontextlist = $transaction->fetchtablelist($messagecontextquery);
    $transaction->sendResponse(200, json_encode($messagecontextlist));
  }
  else if($process == "fetchsinglequestion"){
    //input: selected_id(question id)
    //output: id, question
    $questionquery="SELECT id, question FROM questions WHERE id = '$selected_id' ORDER BY date DESC";
    $questionlist = $transaction->fetchtablelist($questionquery);
    $transaction->sendResponse(200, json_encode($questionlist));
  }
  else if($process == "fetchsinglemessage"){
    //input: selected_id(message id)
    //output: id, message
    $messagequery="SELECT id, message FROM messages WHERE id = '$selected_id' ORDER BY date DESC";
    $messagelist = $transaction->fetchtablelist($messagequery);
    $transaction->sendResponse(200, json_encode($messagelist));
  }
  else if($process == "editquestion"){
    //input: submit_data, selected_id(question id),
    //output:
    $query="UPDATE questions SET question = '$submit_data' WHERE id = '$selected_id'";
    $transaction->submitdata($query);
  }
  else if($process == "editmessage"){
    //input: submit_data, selected_id(question id)
    //output:
    $query="UPDATE messages SET message = '$submit_data' WHERE id = '$selected_id'";
    $fetchedlist = $transaction->submitdata($query);
  }
  else if($process == "deletequestion"){
    //input: selected_id(question id)
    //output:
    $query="UPDATE questions SET delete_status = '1' WHERE id = '$selected_id'";
    $transaction->submitdata($query);
  }
  else if($process == "deletemessage"){
    //input: selected_id(message id)
    //output:
    $query="UPDATE messages SET delete_status = '1' WHERE id = '$selected_id'";
    $transaction->submitdata($query);
  }
  else if($process == "favorites"){
    //input: user_id
    //output: id, class, course
    $all = array(array("0", "All", "0"));
    $query="SELECT classes.id, classes.class, classes.course_id FROM classes
    JOIN favorites ON favorites.class_id = classes.id
    JOIN user_ids ON user_ids.id = favorites.user_id_id
    WHERE user_ids.user_id='$user_id'";
    $fetchedlist = $transaction->fetchtablelist($query);
    $transaction->sendResponse(200, json_encode(array_merge($all,$fetchedlist)));
  }
  else if($process == "submitFavorites"){
    //input: user_id, submit_data(class id)
    //output:
    $countfavquery="SELECT COUNT(favorites.id) FROM favorites
    JOIN user_ids ON user_ids.id = favorites.user_id_id
    WHERE user_ids.user_id='$user_id' AND favorites.class_id = '$submit_data'";
    $favlist = $transaction->fetchtablelist($countfavquery);
    if($favlist[0][0]==0){
      $idquery = "SELECT id FROM user_ids WHERE user_id = '$user_id'";
      $idlist = $transaction->fetchtablelist($idquery);
      $insertfavoritesquery="INSERT INTO favorites (class_id, time, user_id_id) VALUES ('$submit_data', NOW(), {$idlist[0][0]})";
      $transaction->submitdata($insertfavoritesquery);
    }
  }
  else if($process == "removeFavorites"){
    //input: user_id, submit_data(class id)
    //output:
    $deletefavquery="DELETE favorites FROM favorites
    JOIN user_ids ON user_ids.id = favorites.user_id_id
    WHERE user_ids.user_id='$user_id' AND favorites.class_id = '$submit_data'";
    $transaction->submitdata($deletefavquery);
  }
  else if($process == "courses"){
    //input: selected_id(school id)
    //output: id, course
    $query="SELECT id, course FROM courses WHERE school_id='$selected_id'";
    $fetchedlist = $transaction->fetchtablelist($query);
    $transaction->sendResponse(200, json_encode($fetchedlist));
  }
  else if($process == "classes"){
    //input: selected_id(course id)
    //output: id, class
    $query="SELECT id, class FROM classes WHERE course_id='$selected_id'";
    $fetchedlist = $transaction->fetchtablelist($query);
    $transaction->sendResponse(200, json_encode($fetchedlist));
  }
  else if($process == "allquestions"){
    //input:
    //output: id, question, date, views, location, vote, messagecount, imageDirectory
    $query="SELECT id, question, date, views, latitude, longitude, votes FROM questions WHERE delete_status = '0' ORDER BY date DESC";
    $fetchedlist = $transaction->fetchtablelist($query);
    for($listcount=0; $listcount<count($fetchedlist); $listcount++){
      $id = $fetchedlist[$listcount][0];
      $time = strtotime($fetchedlist[$listcount][2]);
      $fetchedlist[$listcount][2] = date("m/d/y g:i A", $time);
      $fetchedlist[$listcount][4] = $transaction->getDistanceBetweenPointsNew($fetchedlist[$listcount][4], $fetchedlist[$listcount][5], $tcu_latitude, $tcu_longitude);
      $fetchedlist[$listcount][5] = $fetchedlist[$listcount][6];
      $messagecountquery="SELECT COUNT(id) FROM messages WHERE question_id='$id' AND delete_status = '0'";
      $fetchedmessagecount = $transaction->fetchtablelist($messagecountquery);
      $fetchedlist[$listcount][6] = $fetchedmessagecount[0][0];
      $imagequery="SELECT COUNT(id) FROM image_directories WHERE type_id='$id' AND type = 'question'";
      $fetchedimage = $transaction->fetchtablelist($imagequery);
      if($fetchedimage[0][0]!=0){
        $imagequery="SELECT directory FROM image_directories WHERE type_id='$id' AND type = 'question'";
        $fetchedimage = $transaction->fetchtablelist($imagequery);
        $fetchedlist[$listcount][7] = "http://www.".substr($fetchedimage[0][0],15);
      }
    }
    $transaction->sendResponse(200, json_encode($fetchedlist));
  }
  else if($process == "questions"){
    //input: selected_id(class id)
    //output: id, question, date, views, location, vote, messagecount, imageDirectory
    $query="SELECT id, question, date, views, latitude, longitude, votes FROM questions WHERE class_id = '$selected_id' AND delete_status = '0' ORDER BY date DESC";
    $fetchedlist = $transaction->fetchtablelist($query);
    for($listcount=0; $listcount<count($fetchedlist); $listcount++){
      $id = $fetchedlist[$listcount][0];
      $time = strtotime($fetchedlist[$listcount][2]);
      $fetchedlist[$listcount][2] = date("m/d/y g:i A", $time);
      $fetchedlist[$listcount][4] = $transaction->getDistanceBetweenPointsNew($fetchedlist[$listcount][4], $fetchedlist[$listcount][5], $tcu_latitude, $tcu_longitude);
      $fetchedlist[$listcount][5] = $fetchedlist[$listcount][6];
      $messagecountquery="SELECT COUNT(id) FROM messages WHERE question_id='$id' AND delete_status = '0'";
      $fetchedmessagecount = $transaction->fetchtablelist($messagecountquery);
      $fetchedlist[$listcount][6] = $fetchedmessagecount[0][0];
      $imagequery="SELECT COUNT(id) FROM image_directories WHERE type_id='$id' AND type = 'question'";
      $fetchedimage = $transaction->fetchtablelist($imagequery);
      if($fetchedimage[0][0]!=0){
        $imagequery="SELECT directory FROM image_directories WHERE type_id='$id' AND type = 'question'";
        $fetchedimage = $transaction->fetchtablelist($imagequery);
        $fetchedlist[$listcount][7] = "http://www.".substr($fetchedimage[0][0],15);
      }
    }
    $transaction->sendResponse(200, json_encode($fetchedlist));
  }
  else if($process == "messages"){
    //input: selected_id(question id)
    //output: id, question, date, views, location, vote, messagecount, imageDirectory
    //output: id, message, date, location, votes, imageDirectory
    $idquery = "SELECT id FROM user_ids WHERE user_id = '$user_id'";
    $idlist = $transaction->fetchtablelist($idquery);
    $questionviewsquery="INSERT INTO question_views (date, user_id_id, question_id) VALUES (NOW(), {$idlist[0][0]}, '$selected_id')";
    $transaction->submitdata($questionviewsquery);
    $viewsquery="UPDATE questions SET views=views+1 WHERE id = '$selected_id'";
    $transaction->submitdata($viewsquery);

    $questionquery="SELECT id, question, date, views, latitude, longitude, votes FROM questions WHERE id = '$selected_id' ORDER BY date DESC";
    $questionlist = $transaction->fetchtablelist($questionquery);
    $time = strtotime($questionlist[0][2]);
    $questionlist[0][2] = date("m/d/y g:i A", $time);
    $questionlist[0][4] = $transaction->getDistanceBetweenPointsNew($questionlist[0][4], $questionlist[0][5], $tcu_latitude, $tcu_longitude);
    $questionlist[0][5] = $questionlist[0][6];
    $messagecountquery="SELECT COUNT(id) FROM messages WHERE question_id='$selected_id'";
    $fetchedmessagecount = $transaction->fetchtablelist($messagecountquery);
    $questionlist[0][6] = $fetchedmessagecount[0][0];
    $imagecountquery="SELECT COUNT(id) FROM image_directories WHERE type_id={$questionlist[0][0]} AND type = 'question'";
    $imagecountlist = $transaction->fetchtablelist($imagecountquery);
    if($imagecountlist[0][0]!=0){
      $imagequery="SELECT directory FROM image_directories WHERE type_id={$questionlist[0][0]} AND type = 'question'";
      $fetchedimage = $transaction->fetchtablelist($imagequery);
      $questionlist[0][7] = "http://www.".substr($fetchedimage[0][0],15);
    }
    $query="SELECT id, message, date, latitude, longitude, votes FROM messages WHERE question_id = '$selected_id' AND delete_status = '0' ORDER BY votes DESC, date DESC";
    $messagelist = $transaction->fetchtablelist($query);
    for($listcount=0; $listcount<count($messagelist); $listcount++){
      $id = $messagelist[$listcount][0];
      $time = strtotime($messagelist[$listcount][2]);
      $messagelist[$listcount][2] = date("m/d/y g:i A", $time);
      $messagelist[$listcount][3] = $transaction->getDistanceBetweenPointsNew( $messagelist[$listcount][3], $messagelist[$listcount][4], $tcu_latitude, $tcu_longitude);
      $messagelist[$listcount][4] = $messagelist[$listcount][5];
      unset($messagelist[$listcount][5]);
      $imagequery="SELECT COUNT(id) FROM image_directories WHERE type_id='$id' AND type = 'message'";
      $fetchedimage = $transaction->fetchtablelist($imagequery);
      if($fetchedimage[0][0]!=0){
        $imagequery="SELECT directory FROM image_directories WHERE type_id='$id' AND type = 'message'";
        $fetchedimage = $transaction->fetchtablelist($imagequery);
        $messagelist[$listcount][5] = "http://www.".substr($fetchedimage[0][0],15);
      }
    }
    $transaction->sendResponse(200, json_encode(array_merge($questionlist,$messagelist)));
  }
  else if($process == "submitQuestions"){
    //input: submit_data['submitData'], submit_data['latitude'], submit_data['longitude'], selected_id(class id), user_id(user id)
    //output:
    $submit_data_submit_data = $submit_data['submitData'];
    $submit_data_latitude = $submit_data['latitude'];
    $submit_data_longitude = $submit_data['longitude'];
    $idquery = "SELECT id FROM user_ids WHERE user_id = '$user_id'";
    $idlist = $transaction->fetchtablelist($idquery);
    $query = "INSERT INTO questions (question, date, latitude, longitude, user_id_id, class_id) VALUES ('$submit_data_submit_data', NOW(), '$submit_data_latitude', '$submit_data_longitude',  {$idlist[0][0]}, '$selected_id')";
    $transaction->submitdata($query);
  }
  else if($process == "submitMessages"){
    //input: submit_data['submitData'], submit_data['latitude'], submit_data['longitude'], selected_id(question id), user_id(user id)
    //output:
    $submit_data_submit_data = $submit_data['submitData'];
    $submit_data_latitude = $submit_data['latitude'];
    $submit_data_longitude = $submit_data['longitude'];
    $idquery = "SELECT id FROM user_ids WHERE user_id = '$user_id'";
    $idlist = $transaction->fetchtablelist($idquery);
    $query = "INSERT INTO messages (message, date, latitude, longitude, user_id_id, question_id) VALUES ('$submit_data_submit_data', NOW(), '$submit_data_latitude', '$submit_data_longitude', {$idlist[0][0]}, '$selected_id')";
    $transaction->submitdata($query);
  }
  else if($process == "submitQuestionsMedia"){
    //input: submit_data['submitData'], submit_data['latitude'], submit_data['longitude'], selected_id(class id), user_id(user id)
    //output:
    $submit_data_submit_data = $submit_data['submitData'];
    $submit_data_latitude = $submit_data['latitude'];
    $submit_data_longitude = $submit_data['longitude'];
    $idquery = "SELECT id FROM user_ids WHERE user_id = '$user_id'";
    $idlist = $transaction->fetchtablelist($idquery);
    $query = "INSERT INTO questions (question, date, latitude, longitude, user_id_id, class_id) VALUES ('$submit_data_submit_data', NOW(), '$submit_data_latitude', '$submit_data_longitude', {$idlist[0][0]}, '$selected_id')";
    $transaction->submitdata($query);

    $last_id_query="SELECT LAST_INSERT_ID();";
    $last_id_array = $transaction->fetchtablelist($last_id_query);
    $last_id = $last_id_array[0][0];
    $upload_file_directory = getcwd().'/images/'.$last_id.basename($_FILES['test']['name']);
    move_uploaded_file($_FILES['test']['tmp_name'], $upload_file_directory);
    $query = "INSERT INTO image_directories (directory, type, type_id) VALUES ('$upload_file_directory', 'question', '$last_id')";
    $transaction->submitdata($query);
  }
  else if($process == "submitMessagesMedia"){
    //input: submit_data['submitData'], submit_data['latitude'], submit_data['longitude'], selected_id(question id), user_id(user id)
    //output:
    $submit_data_submit_data = $submit_data['submitData'];
    $submit_data_latitude = $submit_data['latitude'];
    $submit_data_longitude = $submit_data['longitude'];
    $idquery = "SELECT id FROM user_ids WHERE user_id = '$user_id'";
    $idlist = $transaction->fetchtablelist($idquery);
    $query = "INSERT INTO messages (message, date, latitude, longitude, user_id_id, question_id) VALUES ('$submit_data_submit_data', NOW(), '$submit_data_latitude', '$submit_data_longitude', {$idlist[0][0]}, '$selected_id')";
    $transaction->submitdata($query);

    $last_id_query="SELECT LAST_INSERT_ID();";
    $last_id_array = $transaction->fetchtablelist($last_id_query);
    $last_id = $last_id_array[0][0];
    $upload_file_directory = getcwd().'/images/'.$last_id.basename($_FILES['test']['name']);
    move_uploaded_file($_FILES['test']['tmp_name'], $upload_file_directory);
    $query = "INSERT INTO image_directories (directory, type, type_id) VALUES ('$upload_file_directory', 'message', '$last_id')";
    $transaction->submitdata($query);
  }
  else if($process == "submitQuestionVotes"){
    //input: submit_data['celltag'](question id), submit_data['vote'], submit_data['latitude'], submit_data['longitude'], user_id(user id)
    //output:
    $submit_data_celltag = $submit_data['celltag'];
    $submit_data_vote = $submit_data['vote'];
    $submit_data_latitude = $submit_data['latitude'];
    $submit_data_longitude = $submit_data['longitude'];
    $idquery = "SELECT id FROM user_ids WHERE user_id = '$user_id'";
    $idlist = $transaction->fetchtablelist($idquery);
    $countvotesquery="SELECT COUNT(id) FROM question_votes WHERE question_id = '$submit_data_celltag' AND user_id_id= {$idlist[0][0]}";
    $votecount = $transaction->fetchtablelist($countvotesquery);
    if($votecount[0][0] == 0){
      $updatequestionsquery = "UPDATE questions SET votes = votes + '$submit_data_vote' WHERE id = '$submit_data_celltag'";
      $transaction->submitdata($updatequestionsquery);
      $insertvotesquery = "INSERT INTO question_votes (vote, latitude, longitude, user_id_id, question_id) VALUES ('$submit_data_vote', '$submit_data_latitude', '$submit_data_longitude', {$idlist[0][0]}, '$submit_data_celltag')";
      $transaction->submitdata($insertvotesquery);
    }
    else if ($votecount[0][0] == 1){
      $votequery="SELECT vote FROM question_votes WHERE question_id = '$submit_data_celltag' AND user_id_id= {$idlist[0][0]}";
      $vote = $transaction->fetchtablelist($votequery);
      $updatequestionsquery = "UPDATE questions SET votes = votes + (1-2*{$vote[0][0]}) WHERE id = '$submit_data_celltag'";
      $transaction->submitdata($updatequestionsquery);
      $updatevotesquery = "UPDATE question_votes SET vote = 1 - vote, latitude = '$submit_data_latitude', longitude = '$submit_data_longitude' WHERE question_id = '$submit_data_celltag' AND user_id_id= {$idlist[0][0]}";
      $transaction->submitdata($updatevotesquery);
    }
  }
  else if($process == "submitMessageVotes"){
    //input: submit_data['celltag'](message id), submit_data['vote'], submit_data['latitude'], submit_data['longitude'], user_id(user id)
    //output:
    $submit_data_celltag = $submit_data['celltag'];
    $submit_data_vote = $submit_data['vote'];
    $submit_data_latitude = $submit_data['latitude'];
    $submit_data_longitude = $submit_data['longitude'];
    $idquery = "SELECT id FROM user_ids WHERE user_id = '$user_id'";
    $idlist = $transaction->fetchtablelist($idquery);
    $countvotesquery="SELECT COUNT(id) FROM message_votes WHERE message_id = '$submit_data_celltag' AND user_id_id= {$idlist[0][0]}";
    $votecount = $transaction->fetchtablelist($countvotesquery);
    if($votecount[0][0] == 0){
      $updatemessagesquery = "UPDATE messages SET votes = votes + '$submit_data_vote' WHERE id = '$submit_data_celltag'";
      $transaction->submitdata($updatemessagesquery);
      $insertvotesquery = "INSERT INTO message_votes (vote, latitude, longitude, user_id_id, message_id) VALUES ('$submit_data_vote', '$submit_data_latitude', '$submit_data_longitude', {$idlist[0][0]}, '$submit_data_celltag')";
      $transaction->submitdata($insertvotesquery);
    }
    else if ($votecount[0][0] == 1){
      $votequery="SELECT vote FROM message_votes WHERE message_id = '$submit_data_celltag' AND user_id_id= {$idlist[0][0]}";
      $vote = $transaction->fetchtablelist($votequery);
      $updatemessagesquery = "UPDATE messages SET votes = votes - {$vote[0][0]} + '$submit_data_vote' WHERE id = '$submit_data_celltag'";
      $transaction->submitdata($updatemessagesquery);
      $updatevotesquery = "UPDATE message_votes SET vote = '$submit_data_vote', latitude = '$submit_data_latitude', longitude = '$submit_data_longitude' WHERE message_id = '$submit_data_celltag' AND user_id_id= {$idlist[0][0]}";
      $transaction->submitdata($updatevotesquery);
    }
  }
  else if($process == "contactUs"){
    $msg = "'$submit_data'";
    $msg = wordwrap($msg,70);
    mail("my_email","TCUExchange Request",$msg);
  }
  else if($process == "report"){
    $to="my_email@gmail.com";
    $subject="Report";
    $msg = "<html>
          <body>
            <table width=\"100%\"; rules=\"all\" style=\"border:1px solid #000000;\" cellpadding=\"2\">
            <tr><td colspan=2 style=\"padding: 5px;\">
                <br/>A report was submitted in '$submit_data' for '$selected_id'.
                <br/>Kind Regards,
                <br/>The Exchange Team
            </td></tr>
            <tr><td colspan=2 style=\"background-color:#666666; padding: 5px;\"><i style=\"color:white;\">Thank You.</i></td></tr>
            </table>
          </body>
        </html>";
    $msg = wordwrap($msg,70);
    $headers = "Content-type: text/html; charset=iso-8859-1\r\n";
    //$headers  = 'MIME-Version: 1.0' . "\r\n";
    //$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
    mail($to, $subject, $msg, $headers);
  }
  else {
    $transaction->sendResponse(400, 'Invalid process request');
    return false;
  }
}
else {
  $transaction->sendResponse(204, 'No content');
  return false;
}
?>
