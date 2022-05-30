<table>
    <thead>
    <tr>
        <th>Name</th>
        <th>Email</th>
        <th>Phone Number</th>
        <th>Referral Code</th>
        <th>Referral Count</th>
        <th>Referred Names</th>
        <th>Referred Emails</th>
        <th>Referred Phones</th>
    </tr>
    </thead>
    <tbody>
    @foreach($users as $user)
    <?php 
        $ref_users = \App\User::where('ref_by',$user->id)->get();
        $ref_u = "";
        $ref_e = "";
        $ref_p = "";
        foreach ($ref_users as $us) {
            $ref_u .= ", ".$us->name;
            $ref_e .= ", ".$us->email;
            $ref_p .= ", ".$us->phone;
        }
    ?>
    <?php if(\App\User::where('ref_by',$user->id)->count()>0): ?>
        <tr>
            <td>{{ $user->name }}</td>
            <td>{{ $user->email }}</td>
            <td>{{ $user->phone }}</td>
            <td>{{ $user->ref_code }}</td>
            <td>{{\App\User::where('ref_by',$user->id)->count()}}</td>
            <td>{{$ref_u}}</td>
            <td>{{$ref_e}}</td>
            <td>{{$ref_p}}</td>
        </tr>
    <?php endif; ?>
    @endforeach
    </tbody>
</table>