--created by LionHeartKIng
--coded by Lyris
--Tide Witch of Stellar Vine
function c101020024.initial_effect(c)
	--search1
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetTarget(c101020024.target)
	e0:SetOperation(c101020024.activate)
	c:RegisterEffect(e0)
	--search2
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101020024)
	e1:SetTarget(c101020024.tg)
	e1:SetOperation(c101020024.op)
	c:RegisterEffect(e1)
end
function c101020024.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785e) and c:IsAbleToRemove() and c:GetCode()~=101020024
end
function c101020024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020024.rfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c101020024.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	e1:SetCondition(c101020024.thcon)
	e1:SetOperation(c101020024.thop)
	e1:SetLabel(0)
	tg:RegisterEffect(e1)
end
function c101020024.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101020024.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
function c101020024.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785e) and c:IsAbleToHand() and c:GetCode()~=101020024
end
function c101020024.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020024.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101020024.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101020024.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
