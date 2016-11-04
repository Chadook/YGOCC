--Remorse of Eternity
function c19454009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_START)
	e1:SetCondition(c19454009.condition)
	e1:SetTarget(c19454009.target)
	e1:SetOperation(c19454009.activate)
	c:RegisterEffect(e1)
end
function c19454009.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_BATTLE and not Duel.CheckPhaseActivity()
end
function c19454009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local lp=Duel.GetLP(tp)
	if chk==0 then return lp>100 and Duel.GetLP(tp)<=ag:GetSum(Card.GetAttack) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c19454009.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(dg,REASON_EFFECT) then
		local lp=Duel.GetLP(tp)
		if lp<=100 then return end
		lp=lp-100
		Duel.PayLPCost(tp,lp)
	end
end