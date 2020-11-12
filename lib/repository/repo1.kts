
import org.springframework.stereotype.Service;
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface repo1 : JpaRepository<Bet, Long> {
    @Query("SELECT b.id, b.match, b.result, b.player, b.played, b.counted, b.pointsWon " +
            "FROM Bet b where b.match = :match and b.played = false")
    fun findAllByMatchWhereBetHasNotBeenPlayed(@Param("match") match: Match): List<Bet>
}
