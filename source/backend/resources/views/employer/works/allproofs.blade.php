<?php
    $job = \App\Project::find($id);
?>
<table>
    <thead>
    <tr>
        <th>Candidate Name</th>
        <th>Candidate Email</th>
        <th>Project Name</th>
        <th>Proof</th>
    </tr>
    </thead>
    <tbody>
    @foreach($proofs as $proof)
    <?php $user = \App\User::find($proof->uid); ?>
    @if($user)
        <tr>
            <td>{{ $user->name }}</td>
            <td>{{ $user->email }}</td>
            <td>{{ $job->title }}</td>
            <td>{{ $proof->proof }}</td>
        </tr>
    @endif
    @endforeach
    </tbody>
</table>