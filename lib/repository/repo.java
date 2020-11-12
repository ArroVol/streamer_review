
import edu.ben.cmsc3330.data.model.Student;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.github.juanmougan.prode.repositories.BetsRepository;
import org.springframework.stereotype.Service;

public interface repo extends JpaRepository
public interface StudentRepository extends JpaRepository<Student, Long> {

    Page<Student> findByIdContainingOrderById(Long id, Pageable pageable);

}
