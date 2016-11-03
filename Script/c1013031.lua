--Armored Pendulum Zombie
function c1013031.initial_effect(c)
	--Pendulum Set
	aux.EnablePendulumAttribute(c)
	--[[	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)]]--
	--Change B-Damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1013031,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1013031.rdcon)
	e2:SetOperation(c1013031.rdop)
	c:RegisterEffect(e2)
end
function c1013031.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return ep==tp and tc and tc:IsRace(RACE_ZOMBIE)
end
function c1013031.rdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(1013031,1)) then
		Duel.ChangeBattleDamage(tp,0)
	end
end