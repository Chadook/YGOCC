--Night Clock Wall
function c90000017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,90000017)
	e2:SetTarget(c90000017.target)
	e2:SetOperation(c90000017.operation)
	c:RegisterEffect(e2)
end
function c90000017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=Duel.GetAttacker()
	local bc=c:GetBattleTarget()
	local rec=bc:GetAttack()
	if bc:GetAttack() < bc:GetDefense() then rec=bc:GetDefense() end
	if rec<0 then rec=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c90000017.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end