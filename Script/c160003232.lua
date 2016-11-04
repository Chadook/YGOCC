--
function c160003232.initial_effect(c)
	--ritual level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(c160003232.rlevel)
	c:RegisterEffect(e1)
				--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160003232,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,160003232)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c160003232.thtg)
	e2:SetOperation(c160003232.thop)
	c:RegisterEffect(e2)
		--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c160003232.repcon)
	e3:SetTarget(c160003232.reptg)
	e3:SetValue(c160003232.repval)
	c:RegisterEffect(e3)
end

function c160003232.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x785b) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c160003232.thfilter(c)
	return c:IsSetCard(0x785a) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c160003232.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160003232.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c160003232.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c160003232.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c160003232.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c160003232.repcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c160003232.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x785b) and c:IsType(TYPE_RITUAL) and c:IsReason(REASON_EFFECT)
end
function c160003232.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x785b) and c:IsType(TYPE_RITUAL)
end
function c160003232.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c160003232.repfilter,1,nil,tp) end
	if e:GetHandler():IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(160003232,1)) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		local g=eg:Filter(c160003232.repfilter,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		return true
	else return false end
end
function c160003232.repval(e,c)
	return c==e:GetLabelObject()
end
