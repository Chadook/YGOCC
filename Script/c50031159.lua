function c50031159.initial_effect(c)
 	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c50031159.sumop)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c50031159.chainop)
	c:RegisterEffect(e2)
		--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c50031159.sumsuc)

	c:RegisterEffect(e3)
		--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50031159,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetTarget(c50031159.thtg)
	e4:SetOperation(c50031159.thop)
	c:RegisterEffect(e4)
end
function c50031159.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,50031159)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x785b))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,50031159,RESET_PHASE+PHASE_END,0,1)
end
function c50031159.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard(0x785b) and re:IsActiveType(TYPE_FIELD) then
		Duel.SetChainLimit(c50031159.chainlm)
	end
end
function c50031159.chainlm(e,rp,tp)
	return tp==rp
end
function c50031159.sucfilter(c)
	return c:IsSetCard(0x785b) and c:IsType(TYPE_RITUAL) and bit.band(c:GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c50031159.sumsuc(e,tp,eg,ep,ev,re,r,rp)
		if eg:IsExists(c50031159.sucfilter,1,nil) then return end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c50031159.thfilter(c)
	return c:IsSetCard(0x785b) and not c:IsCode(50031159)and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c50031159.sucop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c50031159.sucfilter,1,nil) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c50031159.cedop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(c50031159.chainlm)
	end
end
function c50031159.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50031159.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c50031159.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50031159.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
 Duel.ConfirmCards(1-tp,g)
end
end