<?php 

$app->get('/api/getAllFlowers', function(){
    require_once('dbconnect.php');
    
    $query = "SELECT * FROM flowers";
    $result = $mysqli->query($query);
    
    while($row = $result->fetch_assoc()){
        $data[] = $row;
    }
    
    if(isset($data)){
        header('Content-Type: application/json');
        echo json_encode($data);
    }
});

$app->get('/api/getOneFlower/{NAME}', function($request){
    require_once('dbconnect.php');
    
    $name = $request->getAttribute('NAME');    
    
    $query = "SELECT SIGHTED, LOCATION, PERSON FROM sightings WHERE NAME ='" . $name . "'ORDER BY SIGHTED DESC LIMIT 10";
    $result = $mysqli->query($query);
    
    while($row = $result->fetch_assoc()){
        $data[] = $row;
    }
    
    if(isset($data)){
        header('Content-Type: application/json');
        echo json_encode($data);
    }
    
});

$app->post('/api/insertFlower', function($request){
    require_once('dbconnect.php');
    
    $insert = "INSERT INTO sightings (NAME, PERSON, LOCATION, SIGHTED) VALUES (?, ?, ?, ?)";
    $stmt = $mysqli->prepare($insert);
    $stmt->bind_param("ssss", $name, $person, $location, $sighted);
    
    $name = $request->getParsedBody()['NAME'];
    $person = $request->getParsedBody()['PERSON'];
    $location = $request->getParsedBody()['LOCATION'];
    $sighted = $request->getParsedBody()['SIGHTED'];
    
    $stmt->execute();    
    
});

$app->put('/api/updateFlower', function($request){
    require_once('dbconnect.php');
    
    $oldName = $request->getParsedBody()['OLDNAME'];
    $oldPerson = $request->getParsedBody()['OLDPERSON'];
    $oldLocation = $request->getParsedBody()['OLDLOCATION'];
    $oldSighted = $request->getParsedBody()['OLDSIGHTED'];
    
    $update = "UPDATE sightings SET PERSON = ?, LOCATION = ?, SIGHTED = ? 
               WHERE NAME = '" . $oldName . "' 
               AND PERSON = '" . $oldPerson . "' 
               AND LOCATION = '" . $oldLocation . "' 
               AND SIGHTED = '" . $oldSighted . "'";  
    
    $stmt = $mysqli->prepare($update);
    $stmt->bind_param("sss", $newPerson, $newLocation, $newSighted);
    
    $newPerson = $request->getParsedBody()['PERSON'];
    $newLocation = $request->getParsedBody()['LOCATION'];
    $newSighted = $request->getParsedBody()['SIGHTED'];
    
    $stmt->execute();
});


?>